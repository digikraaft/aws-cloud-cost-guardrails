# 💸 Common AWS Billing Mistakes (and how to avoid them)

Even with guardrails, it's easy to waste money on AWS. Here are the most common traps for startups:

## 1. Zombie Development Resources
- **Problem**: Leaving high-spec EC2 or RDS instances running 24/7 when they are only needed during business hours.
- **Solution**: Use the `AutoShutdown` tag provided in this project to stop these resources automatically.

## 2. Idle Load Balancers & NAT Gateways
- **Problem**: NAT Gateways and ALBs have a fixed hourly cost (approx. $32/month for NAT, $16/month for ALB) regardless of traffic.
- **Solution**: In dev/test, consider using a single 'Public Instance' or a shared ALB to minimize idle costs.

## 3. Unused Elastic IPs
- **Problem**: AWS charges for Elastic IPs that are *not* associated with a running instance.
- **Solution**: Release EIPs as soon as the associated instance is terminated.

## 4. Log Retention Overload
- **Problem**: CloudWatch Logs default to "Never Expire", which can lead to massive storage bills over time.
- **Solution**: Set a retention policy (e.g., 30 days) for all your log groups.

## 5. Overprovisioned Storage
- **Problem**: Provisioning 1TB of EBS storage "just in case" when you only need 20GB.
- **Solution**: Start small; EBS volumes can be expanded on-the-fly without downtime.

## 6. Snapshot Bloat
- **Problem**: Frequent automated snapshots of RDS or EBS with no cleanup policy.
- **Solution**: Implement lifecycle policies to delete old snapshots.