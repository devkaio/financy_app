abstract class Queries {
  static const String qGetBalances = r"""
query getBalances {
  totalBalance: transaction_aggregate {
    aggregate {
      sum {
        value
      }
    }
  }
  totalIncome: transaction_aggregate(where: {value: {_gt: "0"}}) {
    aggregate {
      sum {
        value
      }
    }
  }
  totalOutcome: transaction_aggregate(where: {value: {_lt: "0"}}) {
    aggregate {
      sum {
        value
      }
    }
  }
}
""";

  static const String qGetTrasactions = r"""
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
}
