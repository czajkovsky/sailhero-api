class Response
  def initialize(_)
    @messages = []
  end

  def add_message(error)
    code = error.split('_')[0]
    messages << { code: code, message: I18n.t("codes.#{error}") }
  end
end
