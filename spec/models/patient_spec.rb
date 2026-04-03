require 'rails_helper'

RSpec.describe Patient, type: :model do
  subject(:patient) { build(:patient) }

  # ── Validations ────────────────────────────────────────────────────────────
  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_numericality_of(:age).only_integer.is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_inclusion_of(:gender).in_array(%w[Male Female Other male female other]) }
  end

  # ── Associations ───────────────────────────────────────────────────────────
  describe "associations" do
    it { is_expected.to have_many(:phi_records) }
    it { is_expected.to have_many(:consents) }
  end

  # ── Invalid cases ──────────────────────────────────────────────────────────
  describe "invalid cases" do
    it "is invalid without name" do
      patient.name = nil
      expect(patient).not_to be_valid
    end

    it "is invalid with negative age" do
      patient.age = -1
      expect(patient).not_to be_valid
    end

    it "is invalid with unrecognised gender" do
      patient.gender = "unknown"
      expect(patient).not_to be_valid
    end

    it "is valid with lowercase gender" do
      patient.gender = "male"
      expect(patient).to be_valid
    end
  end
end
