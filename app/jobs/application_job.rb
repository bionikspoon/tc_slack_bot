# frozen_string_literal: true

class ApplicationJob
  include SuckerPunch::Job
  def _perform
    ActiveRecord::Base.connection_pool.with_connection do
      yield
    end
  end
end
