class ProfileEmails < Spinach::FeatureSteps
  include SharedAuthentication

  step 'I visit profile emails page' do
    visit profile_emails_path
  end

  step 'I should see my emails' do
    page.should have_content(@user.email)
    @user.emails.each do |email|
      page.should have_content(email.email)
    end
  end

  step 'I submit new email "my@email.com"' do
    fill_in "email_email", with: "my@email.com"
    click_button "Add"
  end

  step 'I should see new email "my@email.com"' do
    email = @user.emails.find_by(email: "my@email.com")
    email.should_not be_nil
    page.should have_content("my@email.com")
  end

  step 'I should not see email "my@email.com"' do
    email = @user.emails.find_by(email: "my@email.com")
    email.should be_nil
    page.should_not have_content("my@email.com")
  end
  
  step 'I click link "Remove" for "my@email.com"' do
    # there should only be one remove button at this time
    click_link "Remove"
    # force these to reload as they have been cached
    @user.emails.reload
  end

  step 'I submit duplicate email @user.email' do
    fill_in "email_email", with: @user.email
    click_button "Add"
  end

  step 'I should not have @user.email added' do
    email = @user.emails.find_by(email: @user.email)
    email.should be_nil
  end
end
