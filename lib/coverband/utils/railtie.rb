# frozen_string_literal: true

Coverband.eager_loading_coverage!
module Coverband
  module RailsEagerLoad
    def eager_load!
      Coverband.configuration.logger&.debug('Coverband: set to eager_loading')
      Coverband.eager_loading_coverage!
      super
    ensure
      Coverband.report_coverage(true)
      Coverband.runtime_coverage!
    end
  end
  Rails::Engine.prepend(RailsEagerLoad)

  class Railtie < Rails::Railtie
    initializer 'coverband.configure' do |app|
      app.middleware.use Coverband::Middleware
    end

    config.after_initialize do
      Coverband.report_coverage(true)
      Coverband.configuration.logger&.debug('Coverband: reported after_initialize')
      Coverband.runtime_coverage!
    end

    config.before_initialize do
      Coverband.configuration.logger&.debug('Coverband: set to eager_loading')
      Coverband.eager_loading_coverage!
    end

    rake_tasks do
      load 'coverband/utils/tasks.rb'
    end
  end
end
