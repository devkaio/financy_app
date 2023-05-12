const String mDeleteTransaction = r"""
mutation deleteTransaction($id: uuid!) {
  delete_transaction(where: {id: {_eq: $id}}) {
    affected_rows
  }
}
""";
