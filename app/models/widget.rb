class Widget
  include ActiveModel::Model

  attr_accessor :id, :garden_id, :settings

  def initialize(options={})
    @id = options[:id]
    @garden_id = options[:garden_id]
    @settings = options[:settings]
    init_settings
  end

  def init_settings
    #@settings.each { |s| instance_variable_set("@#{s.name}", s) }
    @settings.each do |s|
      self.singleton_class.class_eval do
        define_method("#{s.name}") { s }
      end
    end
  end

  def to_liquid
    liquid = {}
    @settings.each do |setting|
      liquid[setting.name] = send(setting.name).to_liquid
    end
    liquid
  end
end