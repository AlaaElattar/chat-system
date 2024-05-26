class HealthchecksController < ApplicationController
  def healthcheck
    render json: { status: 'ok' }
  end
end