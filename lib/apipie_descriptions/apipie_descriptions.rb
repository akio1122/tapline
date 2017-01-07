module ApipieDescriptions
  extend ActiveSupport::Concern

  module ClassMethods
    include ClassMethods::AdviceSessions
    include ClassMethods::Ratings

    def apipie(param)
      method = "apipie_#{param.keys[0]}_#{param.values[0]}".to_sym
      public_send(method)
    end

    def apipie_clear(method)
      method_added(method.to_s.split("_")[-1])
    end
  end
end