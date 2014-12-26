class MessagesRepository < OpenStruct
  def initialize(params)
    params[:order] = 'ASC' unless %w(ASC DESC).include?(params[:order])
    params[:sign] = (params[:order] == 'DESC' ? '>=' : '<=')
    params[:messages] = []
    params[:limit] = [1, [params[:limit].to_i, 50].min].max
    super params
    self.messages = fetch_messages
  end

  def all
    {
      messages: messages_array.map { |m| MessageSerializer.new(m).attributes },
      next: next_message_id
    }
  end

  private

  def fetch_messages
    reversed_order = (order == 'ASC' ? 'DESC' : 'ASC')
    Message.where("id #{sign} ?", since)
           .where(region_id: region_id)
           .limit(limit + 1)
           .order("created_at #{reversed_order}")
  end

  def messages_array
    return [] if messages.empty?
    return messages if messages.length < limit + 1
    messages[0...-1]
  end

  def next_message_id
    messages[limit].present? ? messages[limit].id : nil
  end
end
