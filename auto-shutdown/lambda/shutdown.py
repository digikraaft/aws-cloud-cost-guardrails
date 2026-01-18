import boto3
import os
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def get_regions():
    ec2 = boto3.client('ec2')
    regions = [region['RegionName'] for region in ec2.describe_regions()['Regions']]
    return regions

def lambda_handler(event, context):
    dry_run = os.environ.get('DRY_RUN', 'false').lower() == 'true'
    results = {"stopped_ec2": [], "stopped_rds": [], "scaled_ecs": []}
    
    regions = get_regions()
    logger.info(f"Scanning regions: {regions}")

    for region in regions:
        logger.info(f"--- Processing Region: {region} ---")
        ec2 = boto3.client('ec2', region_name=region)
        rds = boto3.client('rds', region_name=region)
        ecs = boto3.client('ecs', region_name=region)

        # 1. EC2 Shutdown
        instances = ec2.describe_instances(
            Filters=[
                {'Name': 'tag:AutoShutdown', 'Values': ['true']},
                {'Name': 'instance-state-name', 'Values': ['running']}
            ]
        )
        ec2_ids = [i['InstanceId'] for r in instances['Reservations'] for i in r['Instances']]
        
        if ec2_ids:
            logger.info(f"[{region}] Found EC2 instances to stop: {ec2_ids}")
            if not dry_run:
                ec2.stop_instances(InstanceIds=ec2_ids)
                results["stopped_ec2"].extend([f"{region}:{i}" for i in ec2_ids])
            else:
                logger.info(f"[{region}] [Dry Run] Would stop EC2 instances")

        # 2. RDS Shutdown
        db_instances = rds.describe_db_instances()
        rds_ids = [
            db['DBInstanceIdentifier'] 
            for db in db_instances['DBInstances'] 
            if any(t.get('Key') == 'AutoShutdown' and t.get('Value') == 'true' for t in db.get('TagList', []))
            and db['DBInstanceStatus'] == 'available'
        ]

        if rds_ids:
            logger.info(f"[{region}] Found RDS instances to stop: {rds_ids}")
            if not dry_run:
                for rds_id in rds_ids:
                    rds.stop_db_instance(DBInstanceIdentifier=rds_id)
                results["stopped_rds"].extend([f"{region}:{i}" for i in rds_ids])
            else:
                logger.info(f"[{region}] [Dry Run] Would stop RDS instances")

        # 3. ECS Shutdown (Scale to 0)
        clusters = ecs.list_clusters()['clusterArns']
        for cluster in clusters:
            services = ecs.list_services(cluster=cluster)['serviceArns']
            if not services: continue
            
            svc_details = ecs.describe_services(cluster=cluster, services=services)['services']
            for svc in svc_details:
                tags = ecs.list_tags_for_resource(resourceArn=svc['serviceArn'])['tags']
                if any(t['key'] == 'AutoShutdown' and t['value'] == 'true' for t in tags):
                    logger.info(f"[{region}] Scaling ECS service {svc['serviceName']} in cluster {cluster} to 0")
                    if not dry_run:
                        ecs.update_service(cluster=cluster, service=svc['serviceName'], desiredCount=0)
                        results["scaled_ecs"].append(f"{region}:{svc['serviceName']}")
                    else:
                        logger.info(f"[{region}] [Dry Run] Would scale ECS service to 0")

    return results