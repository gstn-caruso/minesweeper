# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def index
    render template: 'layouts/application'
  end
end
