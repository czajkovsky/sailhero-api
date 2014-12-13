shared_context 'a successful request' do
  it 'returns an OK (200) status code' do
    expect(response.status).to eq(200)
  end

  it 'is an successful response' do
    expect(response).to be_success
  end
end

shared_context 'a successful create' do
  it 'returns an OK (201) status code' do
    expect(response.status).to eq(201)
  end

  it 'is an successful response' do
    expect(response).to be_success
  end
end

shared_context 'an unauthorized request' do
  it 'returns an OK (401) status code' do
    expect(response.status).to eq(401)
  end

  it 'is not an successful response' do
    expect(response).not_to be_success
  end
end

shared_context 'a forbidden request' do
  it 'returns an OK (403) status code' do
    expect(response.status).to eq(403)
  end

  it 'is not an successful response' do
    expect(response).not_to be_success
  end
end

shared_context 'a failed create/update' do
  it 'returns an unprocessable entity (422) status code' do
    expect(response.status).to eq(422)
  end

  it 'is not an successful response' do
    expect(response).not_to be_success
  end
end

shared_context 'a not successful request' do
  it 'is not an successful response' do
    expect(response).not_to be_success
  end
end
