require 'spec_helper'

describe "Engine", type: :feature do
  describe "GET /rollout" do
    let(:user) { double(:user, :id => 5) }

    before do
      $rollout.active?(:featureA, user)
    end

    it "shows requested rollout features" do
      visit "/rollout"

      expect(page).to have_content("featureA")
    end

    describe "percentage" do
      it "allows changing of the percentage" do
        visit "/rollout"

        within("#featureA .percentage_form") do
          select "100", :from => "percentage"
          click_button "Save"
        end

        expect($rollout.active?(:featureA, user)).to be_truthy
      end

      it "shows the selected percentage" do
        visit "/rollout"

        within("#featureA .percentage_form") do
          select "57", :from => "percentage"
          click_button "Save"
        end

        expect(page).to have_content("#{:featureA} - 57.0%")
        expect($rollout.get(:featureA).percentage).to eq(57.0)
      end
    end

    describe "groups" do
      before do
        allow(user).to receive(:beta_tester?).and_return(true)
        $rollout.define_group(:beta_testers) { |user| user.beta_tester? }
      end

      it "allows selecting of groups" do
        visit "/rollout"

        within("#featureA .groups_form") do
          select "beta_testers", :from => "groups[]"
          click_button "Save"
        end

        expect($rollout.active?(:featureA, user)).to be_truthy
      end

      it "shows the selected groups" do
        visit "/rollout"

        within("#featureA .groups_form") do
          select "beta_testers", :from => "groups[]"
          click_button "Save"
        end

        expect(page).to have_css("select.groups option[selected]", text: "beta_testers")
      end
    end

    describe "users" do
      it "allows adding user ids" do
        visit "/rollout"

        within("#featureA .users_form") do
          fill_in "user_names[]", :with => 5
          click_button "Save"
        end

        expect($rollout.active?(:featureA, user)).to be_truthy
      end

      it "shows the selected percentage" do
        visit "/rollout"

        within("#featureA .users_form") do
          fill_in "user_names[]", :with => 5
          click_button "Save"
        end

        expect(page).to have_css("input.users[value='5']")
      end
    end

    describe "order" do
      before do
        $rollout.active?(:featureB, user)
        $rollout.active?(:anotherFeature, user)
      end

      it "shows features in alphabetical order" do
        visit "/rollout"

        elements = %w(anotherFeature featureA featureB)
        expect(page.body)
          .to match(Regexp.new("#{elements.join('.*')}.*", Regexp::MULTILINE))
      end
    end

    describe "adding a feature" do
      it "displays the added feature in the UI" do
        visit "/rollout"

        within(".add-feature") do
          fill_in "name", with: "featureB"
          click_button "Add Feature"
        end

        expect(page).to have_content("featureB")
      end
    end
  end
end

