const String mUpdateTransaction = r"""
mutation updateTransaction($id: uuid!, $category: String!, $date: timestamptz!, $description: String, $status: Boolean!, $value: numeric!, $id1: uuid = "", $category1: String = "", $date1: timestamptz = "", $description1: String = "", $status1: Boolean = false, $value1: numeric = "") {
  update_transaction_by_pk(pk_columns: {id: $id}, _set: {category: $category, date: $date, description: $description, status: $status, value: $value}) {
    category
    date
    description
    id
    status
    value
  }
}
""";
