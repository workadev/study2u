# == Schema Information
#
# Table name: institutions
#
#  id               :uuid             not null, primary key
#  address          :string
#  area             :string
#  city             :string
#  country          :string
#  created_by_type  :string
#  description      :string
#  institution_type :string
#  latitude         :string
#  logo_data        :text
#  longitude        :string
#  name             :string
#  ownership        :string
#  phone_number     :string
#  post_code        :string
#  reputation       :string
#  scholarship      :boolean          default(FALSE)
#  short_desc       :string
#  size             :string
#  status           :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  created_by_id    :uuid
#  state_id         :uuid
#
# Indexes
#
#  index_institutions_on_state_id  (state_id)
#
class InstitutionResource < BaseResource
  IMAGES = ["images", "institutions.images"]
  INTERESTS = ["interests", "institutions.interests"]
  MAJORS = ["majors", "institutions.majors"]
  VIDEOS = ["staffs", "institutions.staffs"]
  STUDY_LEVELS = ["study_levels", "institutions.study_levels"]
  VIDEOS = ["videos", "institutions.videos"]

  one :state, resource: StateResource

  many :images, resource: ImageResource, if: proc {
    IMAGES.any?{|i| params[:include].try(:include?, i) }
  }
  many :videos, resource: VideoResource, if: proc {
    VIDEOS.any?{|i| params[:include].try(:include?, i) }
  }
  many :interests, resource: InterestResource, if: proc {
    INTERESTS.any?{|i| params[:include].try(:include?, i) }
  }
  many :study_levels, resource: StudyLevelResource, if: proc {
    STUDY_LEVELS.any?{|i| params[:include].try(:include?, i) }
  }
  many :majors, resource: MajorResource, if: proc {
    MAJORS.any?{|i| params[:include].try(:include?, i) }
  }
  many :staffs, resource: StaffResource, if: proc {
    STAFF.any?{|i| params[:include].try(:include?, i) }
  }

  attributes :id, :address, :area, :city, :country, :description, :institution_type, :latitude, :longitude,
    :name, :ownership, :phone_number, :post_code, :reputation, :scholarship, :short_desc, :size, :status

  attribute :is_shortlisted do |resource|
    params[:institution_ids].present? ? params[:institution_ids].include?(resource.id) : false rescue false
  end
end
