# == Schema Information
#
# Table name: majors
#
#  id         :uuid             not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# == Schema Information
#
# Table name: institution_majors
#
#  id              :uuid             not null, primary key
#  duration_extra  :string
#  duration_normal :string
#  fee             :integer
#  intake          :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  institution_id  :uuid
#  major_id        :uuid
#
# Indexes
#
#  index_institution_majors_on_institution_id               (institution_id)
#  index_institution_majors_on_major_id                     (major_id)
#  index_institution_majors_on_major_id_and_institution_id  (major_id,institution_id) UNIQUE
#

class MajorResource < BaseResource
  BRANCHES = ["branches", "majors.branches"]

  many :branches, resource: BranchResource, if: proc {
    BRANCHES.any?{|i| params[:include].try(:include?, i) }
  }

  attributes :id, :name

  [:duration_extra, :duration_normal, :fee, :intake].each do |field_name|
    attribute field_name do |resource|
      resource.send(:try, field_name)
    end
  end
end
