require 'spec_helper'

describe V1::AlertConfirmationsController, type: :controller do

  let(:region) { create(:region) }
  let(:reporter) { create(:user, region_id: region.id) }
  let(:confirmer) { create(:user, region_id: region.id, email: 'b@test.com') }
  let(:confirmer2) { create(:user, region_id: region.id, email: 'c@test.com') }
  let(:alert) { create(:alert, user_id: reporter.id, region_id: region.id) }

  context 'when logged out' do
    describe 'POST#create' do
      before { post :create, id: alert }
      it_behaves_like 'an unauthorized request'
    end

    describe 'DELETE#destroy' do
      before { delete :destroy, id: alert }
      it_behaves_like 'an unauthorized request'
    end
  end

  context 'when logged in' do
    let(:app) { create_client_app }
    let(:reporter_token) { access_token(app, reporter) }
    let(:confirmer_token) { access_token(app, confirmer) }
    let(:confirmer2_token) { access_token(app, confirmer2) }

    describe 'POST#create' do
      context 'tries self confirm alert' do
        before do
          controller.stub(:doorkeeper_token) { reporter_token }
          post :create, id: alert, access_token: reporter_token.token
          alert.reload
        end

        it "doesn't change alert credibility" do
          expect(alert.credibility).to eq(0)
        end

        it_behaves_like 'a forbidden request'
      end

      context 'confirming alert' do
        before do
          controller.stub(:doorkeeper_token) { confirmer_token }
          post :create, id: alert
          controller.stub(:doorkeeper_token) { confirmer2_token }
          post :create, id: alert
          alert.reload
        end

        it_behaves_like 'a successful request'

        it 'includes alert credibility in response' do
          expect(json.alert.credibility).to eq(2)
        end

        it 'includes user vote in response' do
          expect(json.alert.user_vote).to eq(1)
        end

        it 'changes alert credibility' do
          expect(alert.credibility).to eq(2)
        end
      end
    end

    describe 'DELETE#destroy' do
      context 'tries self deny alert' do
        before do
          delete :destroy, id: alert, access_token: reporter_token.token
          alert.reload
        end

        it "doesn't change alert credibility" do
          expect(alert.credibility).to eq(0)
        end

        it_behaves_like 'a forbidden request'
      end

      context 'down votes alert' do
        before do
          delete :destroy, id: alert, access_token: confirmer_token.token
          alert.reload
        end

        it 'changes alert credibility' do
          expect(alert.credibility).to eq(-1)
        end

        it 'switches alert to inactive' do
          expect(alert.active).to eq(false)
          expect(Alert.active.count).to eq(0)
        end

        it 'includes alert credibility in response' do
          expect(json.alert.credibility).to eq(-1)
        end

        it 'includes user vote in response' do
          expect(json.alert.user_vote).to eq(-1)
        end
      end

      context 'votes two times' do
        before do
          controller.stub(:doorkeeper_token) { confirmer_token }
          post :create, id: alert # 1
          delete :destroy, id: alert # -1
        end

        it_behaves_like 'a successful request'

        it 'includes alert credibility in response' do
          expect(json.alert.credibility).to eq(-1)
        end

        context 'votes on inactive alert' do
          before  do
            controller.stub(:doorkeeper_token) { confirmer2_token }
            post :create, id: alert
          end
          it_behaves_like 'a not found request'
        end
      end
    end
  end
end
