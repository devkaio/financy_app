abstract class Mutations {
  static const String mAddNewTransaction = r"""
mutation addNewTransaction($id: uuid!, $category: String!, $date: timestamptz!, $created_at: timestamptz!, $description: String!, $status: Boolean!, $value: numeric!, $user_id: String!) {
  insert_transaction_one(object: {id: $id, date: $date, created_at: $created_at, description: $description, status: $status, value: $value, category: $category, user_id: $user_id}) {
    category
    created_at
    date
    description
    id
    status
    value
    user_id
  }
}""";

  static const String mUpdateTransaction = r"""
mutation updateTransaction($id: uuid!, $category: String!, $date: timestamptz!, $description: String!, $value: numeric!, $status: Boolean!, $created_at: timestamptz!) {
  update_transaction_by_pk(pk_columns: {id: $id}, _set: { category: $category, date: $date, description: $description, status: $status, value: $value, created_at: $created_at}) {
    category
    created_at
    date
    description
    id
    status
    value
    user_id
  }
}
""";

  static const String mDeleteTransaction = r"""
mutation deleteTransaction($id: uuid!) {
  delete_transaction(where: {id: {_eq: $id}}) {
    affected_rows
  }
}
""";
}
