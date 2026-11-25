enum SingleOrderStatus {
  pending,
  inPreparation,
  underReceipt,
  underReview,
  prepared,
  shipped,
  arrived,
  completed,
  canceled,
}

extension SingleOrderStatusMapper on SingleOrderStatus {
  static SingleOrderStatus fromApi(String value) {
    switch (value) {
      case 'pending':
      case 'new':
        return SingleOrderStatus.pending;
      case 'in_preparation':
        return SingleOrderStatus.inPreparation;
      case 'under_receipt':
        return SingleOrderStatus.underReceipt;
      case 'under_review':
        return SingleOrderStatus.underReview;
      case 'prepared':
        return SingleOrderStatus.prepared;
      case 'shipped':
        return SingleOrderStatus.shipped;
      case 'arrived':
        return SingleOrderStatus.arrived;
      case 'completed':
        return SingleOrderStatus.completed;
      case 'canceled':
        return SingleOrderStatus.canceled;
      default:
        return SingleOrderStatus.pending;
    }
  }

  int get driverStatus {
    switch (this) {
      case SingleOrderStatus.pending ||
            SingleOrderStatus.underReceipt ||
            SingleOrderStatus.underReview:
        return 1;
      case SingleOrderStatus.inPreparation || SingleOrderStatus.prepared:
        return 2;
      case SingleOrderStatus.shipped || SingleOrderStatus.arrived:
        return 3;
      case SingleOrderStatus.completed || SingleOrderStatus.canceled:
        return 4;
    }
  }

  int get pickupStatus {
    switch (this) {
      case SingleOrderStatus.pending ||
            SingleOrderStatus.underReceipt ||
            SingleOrderStatus.underReview:
        return 1;
      case SingleOrderStatus.inPreparation:
        return 2;
      case SingleOrderStatus.shipped ||
            SingleOrderStatus.arrived ||
            SingleOrderStatus.prepared:
        return 3;
      case SingleOrderStatus.completed || SingleOrderStatus.canceled:
        return 4;
    }
  }
}
