const String mAddNewTransaction = r"""
mutation addNewTransaction($category: String!, $date: timestamptz!, $description: String!, $status: Boolean!, $value: numeric!, $user_id: String!) {
  insert_transaction_one(object: {date: $date, description: $description, status: $status, value: $value, category: $category, user_id: $user_id}) {
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
