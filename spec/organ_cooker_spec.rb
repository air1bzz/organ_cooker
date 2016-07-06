require 'spec_helper'

describe OrganCooker::Project do
  before do
    @test_1 = OrganCooker::Project.new("mantes-la-jolie", "18", "435")
    @test_2 = OrganCooker::Project.new("saint léonard", "15", "440")
  end

  describe "#name" do
    it "should return capitalized words" do
      @test_1.name.must_equal "Mantes-La-Jolie"
    end

    it "should return capitalized words even with accents" do
      @test_2.name.must_equal "Saint Léonard"
    end
  end

  describe "#speed_of_sound" do
    it "sould return the sound speed" do
      @test_1.speed_of_sound.must_equal 342.426
      @test_2.speed_of_sound.must_equal 340.605
    end
  end
end

describe OrganCooker::Manual do
  before do
    @manual = OrganCooker::Manual.new("grand-orgue", "56")
  end

  describe "#name" do
    it "should return capitalized words" do
      @manual.name.must_equal "Grand-Orgue"
    end
  end
end

describe OrganCooker::Rank do
  before do
    p = OrganCooker::Project.new("mantes-la-jolie", "18", "435")
    @test_1 = OrganCooker::RankTypeFlute.new("montre", "8", "145", "6", "56", "c1", p.speed_of_sound, p.diapason)
    @test_2 = OrganCooker::RankTypeBourdon.new("bourdon", "8", "86", "5", "64", "a0", p.speed_of_sound, p.diapason)
    @test_3 = OrganCooker::RankTypeMixtures.new("plein jeu", {:rang1=>["2", "2 2/3", "4", "8"], :rang2=>["-", "2", "2 2/3", "4"], :rang3=>["-", "-", "2", "2 2/3"]}, "84", "7", "56", "c1", p.speed_of_sound, p.diapason, "c1:c2:c3:c4", "3")
    @test_4 = OrganCooker::RankTypeFlute.new("grosse Tierce", "1 3/5", "50", "5", "61", "c1", p.speed_of_sound, p.diapason)
  end

  describe "#name" do
    it "should return capitalized words with height" do
      @test_1.name.must_equal "Montre 8'"
      @test_2.name.must_equal "Bourdon 8'"
    end

    it "should return capitalized words with roman number of rows" do
      @test_3.name.must_equal "Plein Jeu I-III"
    end

    it "should return capitalized words with fraction" do
      @test_4.name.must_equal "Grosse Tierce 1' 3/5"
    end
  end

  describe "#sizes" do
    it "should return an array of inside diameters" do
      @test_1.sizes.must_equal [145, 140, 135, 130, 125, 120, 116, 112, 108, 104, 100, 96, 93, 89, 86, 83, 80, 77, 74, 71, 69, 66, 64, 61, 59, 57, 55, 53, 51, 49, 47, 46, 44, 42, 41, 39, 38, 36, 35, 34, 33, 31, 30, 29, 28, 27, 26, 25, 24, 23, 22, 22, 21, 20, 19, 19]
      @test_2.sizes.must_equal [86, 83, 80, 78, 75, 73, 70, 68, 66, 64, 62, 59, 58, 56, 54, 52, 50, 49, 47, 45, 44, 43, 41, 40, 38, 37, 36, 35, 34, 33, 31, 30, 29, 28, 28, 27, 26, 25, 24, 23, 22, 22, 21, 20, 20, 19, 18, 18, 17, 17, 16, 16, 15, 15, 14, 14, 13, 13, 12, 12, 12, 11, 11, 10]
    end
  end
end
