output "msk_cluster_arn" {
  value = aws_msk_cluster.msk.arn
}

output "msk_current_version" {
  value = aws_msk_cluster.msk.current_version
}

output "msk_zookeeper_connect_string" {
  value = aws_msk_cluster.msk.zookeeper_connect_string
}