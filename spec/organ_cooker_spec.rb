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
    it "should return the sound speed" do
      @test_1.speed_of_sound.must_equal 342.426
      @test_2.speed_of_sound.must_equal 340.605
    end
  end
end

describe OrganCooker::WindChest do
  before do
    @test_1 = OrganCooker::WindChest.new("grand-orgue", "56")
  end

  describe "#name" do
    it "should return capitalized words" do
      @test_1.name.must_equal "Grand-Orgue"
    end
  end

  describe "#last_note" do
    it "should return the last note" do
      @test_1.last_note.must_equal OrganCooker::Note.new("G5")
    end
  end
end

describe OrganCooker::RankTypeFlute do
  before do
    p = OrganCooker::Project.new("mantes-la-jolie", "18", "440")
    w = OrganCooker::WindChest.new("grand-orgue", "56", "C1")
    r = OrganCooker::WindChest.new("grand-orgue", "61", "C1")
    @test_1 = OrganCooker::RankTypeFlute.new("montre", "8", "145", "6", w, p)
    #@test_2 = OrganCooker::RankTypeBourdon.new("bourdon", "8", "86", "5", "64", "a0", p.speed_of_sound, p.diapason)
    #@test_3 = OrganCooker::RankTypeMixtures.new("plein jeu", {:rang1=>["2", "2 2/3", "4", "8"], :rang2=>["-", "2", "2 2/3", "4"], :rang3=>["-", "-", "2", "2 2/3"]}, "84", "7", "56", "c1", p.speed_of_sound, p.diapason, "c1:c2:c3:c4", "3")
    @test_4 = OrganCooker::RankTypeFlute.new("grosse Tierce", "1 3/5", "50", "5", r, p, first_note: "C2")
  end

  describe "#name" do
    it "should return capitalized words with height" do
      @test_1.name.must_equal "Montre 8'"
      #@test_2.name.must_equal "Bourdon 8'"
    end

    # it "should return capitalized words with roman number of rows" do
    #   @test_3.name.must_equal "Plein Jeu I-III"
    # end

    it "should return capitalized words with fraction" do
      @test_4.name.must_equal "Grosse Tierce 1' 3/5"
    end
  end

  describe "#sizes" do
    it "should return an array of inside diameters" do
      @test_1.sizes.must_equal [145, 140, 135, 130, 125, 120, 116, 112, 108, 104, 100, 96, 93, 89, 86, 83, 80, 77, 74, 71, 69, 66, 64, 61, 59, 57, 55, 53, 51, 49, 47, 46, 44, 42, 41, 39, 38, 36, 35, 34, 33, 31, 30, 29, 28, 27, 26, 25, 24, 23, 22, 22, 21, 20, 19, 19]
      #@test_2.sizes.must_equal [86, 83, 80, 78, 75, 73, 70, 68, 66, 64, 62, 59, 58, 56, 54, 52, 50, 49, 47, 45, 44, 43, 41, 40, 38, 37, 36, 35, 34, 33, 31, 30, 29, 28, 28, 27, 26, 25, 24, 23, 22, 22, 21, 20, 20, 19, 18, 18, 17, 17, 16, 16, 15, 15, 14, 14, 13, 13, 12, 12, 12, 11, 11, 10]
    end
  end

  describe "#notes" do
    it "should return an array of string notes" do
      @test_1.notes.must_equal ["C1", "C#1", "D1", "D#1", "E1", "F1", "F#1", "G1", "G#1", "A1", "A#1", "B1", "C2", "C#2", "D2", "D#2", "E2", "F2", "F#2", "G2", "G#2", "A2", "A#2", "B2", "C3", "C#3", "D3", "D#3", "E3", "F3", "F#3", "G3", "G#3", "A3", "A#3", "B3", "C4", "C#4", "D4", "D#4", "E4", "F4", "F#4", "G4", "G#4", "A4", "A#4", "B4", "C5", "C#5", "D5", "D#5", "E5", "F5", "F#5", "G5"]
      @test_4.notes.must_equal ["C2", "C#2", "D2", "D#2", "E2", "F2", "F#2", "G2", "G#2", "A2", "A#2", "B2", "C3", "C#3", "D3", "D#3", "E3", "F3", "F#3", "G3", "G#3", "A3", "A#3", "B3", "C4", "C#4", "D4", "D#4", "E4", "F4", "F#4", "G4", "G#4", "A4", "A#4", "B4", "C5", "C#5", "D5", "D#5", "E5", "F5", "F#5", "G5", "G#5", "A5", "A#5", "B5", "C6"]
    end
  end

  describe "#frequencies" do
    it "should return an array of frequencies" do
      @test_1.frequencies.must_equal [65.41, 69.3, 73.42, 77.78, 82.41, 87.31, 92.5, 98.0, 103.83, 110.0, 116.54, 123.47, 130.81, 138.59, 146.83, 155.56, 164.81, 174.61, 185.0, 196.0, 207.65, 220.0, 233.08, 246.94, 261.63, 277.18, 293.66, 311.13, 329.63, 349.23, 369.99, 392.0, 415.3, 440.0, 466.16, 493.88, 523.25, 554.37, 587.33, 622.25, 659.26, 698.46, 739.99, 783.99, 830.61, 880.0, 932.33, 987.77, 1046.5, 1108.73, 1174.66, 1244.51, 1318.51, 1396.91, 1479.98, 1567.98]
      @test_4.frequencies.must_equal [654.06, 692.96, 734.16, 777.82, 824.07, 873.07, 924.99, 979.99, 1038.26, 1100.0, 1165.41, 1234.71, 1308.13, 1385.91, 1468.32, 1555.63, 1648.14, 1746.14, 1849.97, 1959.98, 2076.52, 2200.0, 2330.82, 2469.42, 2616.26, 2771.83, 2936.65, 3111.27, 3296.28, 3492.28, 3699.94, 3919.95, 4153.05, 4400.0, 4661.64, 4938.83, 5232.51, 5543.65, 5873.3, 6222.54, 6592.55, 6984.56, 7399.89, 7839.91, 8306.09, 8800.0, 9323.28, 9877.67, 10465.02]
    end
  end
end
