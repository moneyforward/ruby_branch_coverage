Rails.application.routes.draw do
  resources :users
  mount BranchcovXmlrubySonar::Engine => "/BranchcovXmlrubySonar"
end
