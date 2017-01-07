module Tokenable
  module ClassMethods

    def verifier
      ActiveSupport::MessageVerifier.new(Getadvice::Application.config.secret_key_base)
    end

    def from_access_token(token)
      id = verifier.verify(token)
      find_by(id: id)
    rescue ActiveSupport::MessageVerifier::InvalidSignature
      nil
    end

    def create_access_token(advice_session)
      verifier.generate(advice_session.id)
    end
  end

  module InstanceMethods

    def access_token
      self.class.create_access_token(self)
    end
  end

  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end
