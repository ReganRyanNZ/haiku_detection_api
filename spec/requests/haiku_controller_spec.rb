require 'rails_helper'

RSpec.describe 'Haiku API', type: :request do

  def json
    JSON.parse(response.body)
  end

  describe 'POST /haiku' do
    context "with no input" do
      before { post '/haiku' }

      it 'returns not found' do
        expect(json["status"]).to eq("not_found")
      end

      it 'returns 200' do
        expect(response).to have_http_status(200)
      end
    end

    context "with not enough syllables" do
      before { post '/haiku', params: {input: "one two three four five six seven eight nine ten"} }

      it 'returns not found' do
        expect(json["status"]).to eq("not_found")
      end

      it 'returns 200' do
        expect(response).to have_http_status(200)
      end
    end

    context "with too many syllables" do
      before { post '/haiku', params: {input: "a perfect haiku, it is written on the fly, without thoughtfulness, but this one is too long"} }

      it 'returns not found' do
        expect(json["status"]).to eq("not_found")
      end

      it 'returns 200' do
        expect(response).to have_http_status(200)
      end
    end

    context "with correct syllables but would split words in half" do
      before { post '/haiku', params: {input: "a perfect haiku, it is written on the flyer, with thoughtfulness"} }

      it 'returns not found' do
        expect(json["status"]).to eq("not_found")
      end

      it 'returns 200' do
        expect(response).to have_http_status(200)
      end
    end

    context "with unknown words" do
      before { post '/haiku', params: {input: "a perfect Pooface, it is written on the fly, without thoughtfulness"} }

      it 'returns not found' do
        expect(json["status"]).to eq("not_found")
      end

      it 'returns 200' do
        expect(response).to have_http_status(200)
      end
    end

    context "with correct syllables and word separation" do
      before { post '/haiku', params: {input: "a perfect haiku, it is written on the fly, without thoughtfulness"} }

      it 'returns success' do
        expect(json["status"]).to eq("success")
      end

      it 'returns the haiku' do
        expect(json["message"]).to eq("A perfect haiku,\nIt is written on the fly,\nWithout thoughtfulness")
      end

      it 'returns 200' do
        expect(response).to have_http_status(200)
      end
    end

  end
end