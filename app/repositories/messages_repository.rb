class MessagesRepository < OpenStruct
  def initialize(params)
    params[:order] = 'ASC' unless %w(ASC DESC).include?(params[:order])
    params[:sign] = (params[:order] == 'DESC' ? '>=' : '<=')
    super params
  end

  def messages
    Message.where("id #{sign} ?", since)
           .limit(limit + 1)
           .where(region_id: region_id)
  end
end
