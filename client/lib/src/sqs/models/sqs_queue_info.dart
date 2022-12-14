class ModelSqsQueueInfo {
  // url
  final String queueUrl;

  // type ->  normal / attach
  final bool isAttach;

  // db id
  final String? id;

  ModelSqsQueueInfo({
    required this.queueUrl,
    this.isAttach = false,
    this.id,
  });

  queueName() {
    return queueUrl.split("/").last;
  }
}
