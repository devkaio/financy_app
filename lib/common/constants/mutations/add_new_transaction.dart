const String mAddNewTransaction = r"""
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
