class ModelSqsCreate {
  late final String queueName;
  late final bool isFifo;
}

class ModelSqsMessageCreate {
  late final String messageContent;
  late final bool isEncodeToBase64;
}
