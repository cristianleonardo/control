class User < ApplicationRecord
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  default_scope { order(:firstname, :lastname) }
  scope :internal, -> { where(developer: false) }

  before_create { generate_token(:invitation_token) }
  after_create :send_invitation

  def password_required?
    !password.blank? && !password_confirmation.blank?
  end

  def send_invitation
    generate_token(:invitation_token)
    self.invitation_sent_at = Time.zone.now
    save!
    UserMailer.invitation(self).deliver_now
  end

  def generate_token(column)
    loop do
      self[column] = SecureRandom.urlsafe_base64
      break unless User.exists?(column => self[column])
    end
  end
end
