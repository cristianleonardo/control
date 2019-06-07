module DocumentsHelper
  def fetch_params_hash(document)
    if document.document_type == 'ACT'
      params_hash = {minute_id: document.id}
    else
      params_hash = {letter_id: document.id}
    end
  end
end
