# Cassandra Terraform module
Terraform module to deploy cassandra in k8s cluster on GCP using helm [chart]

## Install with specific cluster size
By default, cassandra will be created with 3 nodes. If you want to change the cluster size during installation, you can edit `config.cluster_size` in `values.yaml`


## Install with specific resource size
By default, it will create a cassandra with CPU 2 vCPU and 4Gi of memory which is suitable for development environment.
If you want to use it for production, I would recommend to update the CPU to 4 vCPU and 16Gi. Also increase size of `max_heap_size` and `heap_new_size`.
To update the settings, edit `values.yaml`

## Install with specific node
Sometime you may need to deploy your cassandra to specific nodes to allocate resources. You can use node selector by set `nodes.enabled` to `true` in `values.yaml`
For example, you have 6 vms in node pools and you want to deploy cassandra to node which labeled as `cloud.google.com/gke-nodepool: pool-db`

Set the following values in `values.yaml`

```yaml
nodes:
  enabled: true
  selector:
    nodeSelector:
      cloud.google.com/gke-nodepool: pool-db
```

## Configuration

The following table lists the configurable parameters of the Cassandra chart and their default values.

| Parameter                  | Description                                     | Default                                                    |
| -----------------------    | ---------------------------------------------   | ---------------------------------------------------------- |
| `image.repo`                         | `cassandra` image repository                    | `cassandra`                                                |
| `image.tag`                          | `cassandra` image tag                           | `3.11.3`                                                   |
| `image.pullPolicy`                   | Image pull policy                               | `Always` if `imageTag` is `latest`, else `IfNotPresent`    |
| `image.pullSecrets`                  | Image pull secrets                              | `nil`                                                      |
| `config.cluster_domain`              | The name of the cluster domain.                 | `cluster.local`                                            |
| `config.cluster_name`                | The name of the cluster.                        | `cassandra`                                                |
| `config.cluster_size`                | The number of nodes in the cluster.             | `3`                                                        |
| `config.seed_size`                   | The number of seed nodes used to bootstrap new clients joining the cluster.                            | `2` |
| `config.seeds`                       | The comma-separated list of seed nodes.         | Automatically generated according to `.Release.Name` and `config.seed_size` |
| `config.num_tokens`                  | Initdb Arguments                                | `256`                                                      |
| `config.dc_name`                     | Initdb Arguments                                | `DC1`                                                      |
| `config.rack_name`                   | Initdb Arguments                                | `RAC1`                                                     |
| `config.endpoint_snitch`             | Initdb Arguments                                | `SimpleSnitch`                                             |
| `config.max_heap_size`               | Initdb Arguments                                | `2048M`                                                    |
| `config.heap_new_size`               | Initdb Arguments                                | `512M`                                                     |
| `config.ports.cql`                   | Initdb Arguments                                | `9042`                                                     |
| `config.ports.thrift`                | Initdb Arguments                                | `9160`                                                     |
| `config.ports.agent`                 | The port of the JVM Agent (if any)              | `nil`                                                      |
| `config.start_rpc`                   | Initdb Arguments                                | `false`                                                    |
| `configOverrides`                    | Overrides config files in /etc/cassandra dir    | `{}`                                                       |
| `commandOverrides`                   | Overrides default docker command                | `[]`                                                       |
| `argsOverrides`                      | Overrides default docker args                   | `[]`                                                       |
| `env`                                | Custom env variables                            | `{}`                                                       |
| `persistence.enabled`                | Use a PVC to persist data                       | `true`                                                     |
| `persistence.storageClass`           | Storage class of backing PVC                    | `nil` (uses alpha storage class annotation)                |
| `persistence.accessMode`             | Use volume as ReadOnly or ReadWrite             | `ReadWriteOnce`                                            |
| `persistence.size`                   | Size of data volume                             | `10Gi`                                                     |
| `resources`                          | CPU/Memory resource requests/limits             | Memory: `4Gi`, CPU: `2`                                    |
| `service.type`                       | k8s service type exposing ports, e.g. `NodePort`| `ClusterIP`                                                |
| `podManagementPolicy`                | podManagementPolicy of the StatefulSet          | `OrderedReady`                                             |
| `podDisruptionBudget`                | Pod distruption budget                          | `{}`                                                       |
| `podAnnotations`                     | pod annotations for the StatefulSet             | `{}`                                                       |
| `updateStrategy.type`                | UpdateStrategy of the StatefulSet               | `OnDelete`                                                 |
| `livenessProbe.initialDelaySeconds`  | Delay before liveness probe is initiated        | `90`                                                       |
| `livenessProbe.periodSeconds`        | How often to perform the probe                  | `30`                                                       |
| `livenessProbe.timeoutSeconds`       | When the probe times out                        | `5`                                                        |
| `livenessProbe.successThreshold`     | Minimum consecutive successes for the probe to be considered successful after having failed.           | `1` |
| `livenessProbe.failureThreshold`     | Minimum consecutive failures for the probe to be considered failed after having succeeded.             | `3` |
| `readinessProbe.initialDelaySeconds` | Delay before readiness probe is initiated       | `90`                                                       |
| `readinessProbe.periodSeconds`       | How often to perform the probe                  | `30`                                                       |
| `readinessProbe.timeoutSeconds`      | When the probe times out                        | `5`                                                        |
| `readinessProbe.successThreshold`    | Minimum consecutive successes for the probe to be considered successful after having failed.           | `1` |
| `readinessProbe.failureThreshold`    | Minimum consecutive failures for the probe to be considered failed after having succeeded.             | `3` |
| `rbac.create`                        | Specifies whether RBAC resources should be created                                                  | `true` |
| `serviceAccount.create`              | Specifies whether a ServiceAccount should be created                                                | `true` |
| `serviceAccount.name`                | The name of the ServiceAccount to use           |                                                            |
| `backup.enabled`                     | Enable backup on chart installation             | `false`                                                    |
| `backup.schedule`                    | Keyspaces to backup, each with cron time        |                                                            |
| `backup.annotations`                 | Backup pod annotations                          | iam.amazonaws.com/role: `cain`                             |
| `backup.image.repo`                  | Backup image repository                         | `nuvo/cain`                                                |
| `backup.image.tag`                   | Backup image tag                                | `0.4.1`                                                    |
| `backup.extraArgs`                   | Additional arguments for cain                   | `[]`                                                       |
| `backup.env`                         | Backup environment variables                    | AWS_REGION: `us-east-1`                                    |
| `backup.resources`                   | Backup CPU/Memory resource requests/limits      | Memory: `1Gi`, CPU: `1`                                    |
| `backup.destination`                 | Destination to store backup artifacts           | `s3://bucket/cassandra`                                    |
| `exporter.enabled`                   | Enable Cassandra exporter                       | `false`                                                    |
| `exporter.image.repo`                | Exporter image repository                       | `criteord/cassandra_exporter`                              |
| `exporter.image.tag`                 | Exporter image tag                              | `2.0.2`                                                    |
| `exporter.port`                      | Exporter port                                   | `5556`                                                     |
| `exporter.jvmOpts`                   | Exporter additional JVM options                 |                                                            |
| `affinity`                           | Kubernetes node affinity                        | `{}`                                                       |
| `tolerations`                        | Kubernetes node tolerations                     | `[]`                                                       |


## Scale cassandra
When you want to change the cluster size of your cassandra, you can edit `config.cluster_size` in `values.yaml`.

---
Visit [chart] repo for more information about customization and cassandra chart itself.


[chart]: https://github.com/helm/charts/tree/master/incubator/cassandra