const String qGetTrasactions = r"""
query getTransactions($limit: Int, $offset: Int) {
  transaction(limit: $limit, order_by: {date: desc}, offset: $offset) {
    category
    created_at
    date
    description
    id
    status
    user_id
    value
  }
}
""";
