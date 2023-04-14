const String qGetLatestTransactions = """
query getLatestTransactions {
  transaction(limit: 5, order_by: {date: desc}) {
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
