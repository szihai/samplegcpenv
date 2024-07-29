resource "google_service_account" "service_accounts" {
  for_each     = { for sa in var.service_accounts : sa.account_id => sa }
  account_id   = each.value.account_id
  display_name = each.value.display_name
  project      = var.project_id
}

resource "google_project_iam_member" "sa_iam_bindings" {
  for_each = {
    for binding in flatten([
      for sa in var.service_accounts : [
        for role in sa.roles : {
          account_id = sa.account_id
          role       = role
        }
      ]
    ]) : "${binding.account_id}-${binding.role}" => binding
  }
  
  project = var.project_id
  role    = each.value.role
  member  = "serviceAccount:${google_service_account.service_accounts[each.value.account_id].email}"
}
