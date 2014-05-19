require 'spec_helper'


describe "Authentification" do
  subject {page}

  describe "signin page" do
    before {visit signin_path}

    it { should have_content('Sign in') }
    it { should have_title('Sign in') }
  end

  describe "signin" do
    before {visit signin_path}

    describe "with invalid information" do
      before { click_button "Sign in"}

      it {should have_title('Sign in')}
      it {should have_selector('div.alert.alert-error')}

      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-error') }
      end

      describe "with valid information" do
        let(:user) {FactoryGirl.create(:user)}
        before do

          fill_in "Email",            with: user.email.upcase
          fill_in "Password" ,        with: user.password
          click_button  "Sign in"
        end

        it { should have_title(user.name)}
        it { should have_link('Profile',    href: user_path(user))}
        it { should have_link('Sign out',   href: signout_path)}
        it { should_not have_link('Sign in',    href: signin_path)}

        describe "followed by signout" do
          before { click_link "Sign out" }
          it { should have_link('Sign in') }
        end
      end

    end
  end

  # check if a signed user see the page has it should be
  describe "with valid information" do
    let(:user) {FactoryGirl.create(:user)}
    before{sign_in user}

    it {should have_title(user.name)}
    it {should have_link('Profile', href: user_path(user))}
    it {should have_link('Settings', href: edit_user_path(user))}
    it {should_not have_link('Sign in'), href: signin_path}


  end


  #verify qu'un utilisateur ne peut pas aller a une page qui
  # ne lui appartient pas. Un user doit etre signer
  describe "authorization" do
    let(:user) {FactoryGirl.create(:user)}


    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          fill_in "Email",    with: user.email
          fill_in "Password", with: user.password
          click_button "Sign in"
        end

        describe "after signing in" do

          it "should render the desired protected page" do
            expect(page).to have_title('Edit user')
          end
        end
      end
    end

    describe "in the user controller" do
      describe "visiting the edit page when not signed in " do
        before{ visit edit_user_path(user)}
        it{ should have_title("Sign in")}
      end

      describe "submitting to the update action" do
        before {patch user_path(user)}# utiliser patch permet d<acceder au update du controller
        #
        specify {expect(response).to redirect_to(signin_path)}
      end

      describe "visiting the user index" do
        before{ visit users_path}
        it{ should have_title("Sign in")}
      end
    end


    #si un utilisateur essai d'éditer un autre
    describe "as wrong user" do
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before {sign_in user,no_capybara: true }

      describe "submitting a GET request to the User#edit action" do
        before{ get edit_user_path(wrong_user)}
        specify {expect(response.body).not_to match(full_title('Edit user'))}
        specify {expect(response).to redirect_to(root_url)}
      end

      describe "submitting a PATH request to the User#update action" do
        before {patch user_path(wrong_user)}
        specify {expect(response).to redirect_to(root_url)}
      end

    end


    #le comportement d'un user pas admin
    # un user non amdin va essayer de delete un user admin
    describe "as non-admin user" do
      let (:user) { FactoryGirl.create(:user)}
      let (:non_admin) { FactoryGirl.create(:user)}
      before do
        sign_in non_admin, no_capybara: true # important de faire le no_capybara sinon
                                            # le controller ne voit pas qu'il est sign_in
      end

      describe "submitting a DELETE request to the user#destroy action " do
        before { delete user_path(user)}
        specify { expect(response).to redirect_to(root_url)}

        specify { expect(user).to_not be_nil}
      end
    end

  end


end

