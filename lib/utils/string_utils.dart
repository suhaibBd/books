extension Validation on String {
  bookTitleValidate() {
    if (isEmpty) {
      return "enter book title";
    }
  }

  bookDescValidate() {
    if (isEmpty) {
      return "enter book desc";
    }
  }

  bookAuthorValidate() {
    if (isEmpty) {
      return "enter book author naeme";
    }
  }
}
