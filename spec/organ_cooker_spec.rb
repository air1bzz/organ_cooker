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
    @test_2 = OrganCooker::RankTypeFlute.new("flûte harmonique", "8", "83", "3 4", r, p, first_note: "C2", prog_change: {note: "f3", size: nil})
    @test_3 = OrganCooker::RankTypeFlute.new("flûte harmonique", "8", "83", "3 7.5", r, p, first_note: "C1", prog_change: {note: "f3", size: 83})
    #@test_2 = OrganCooker::RankTypeBourdon.new("bourdon", "8", "86", "5", "64", "a0", p.speed_of_sound, p.diapason)
    #@test_3 = OrganCooker::RankTypeMixtures.new("plein jeu", {:rang1=>["2", "2 2/3", "4", "8"], :rang2=>["-", "2", "2 2/3", "4"], :rang3=>["-", "-", "2", "2 2/3"]}, "84", "7", "56", "c1", p.speed_of_sound, p.diapason, "c1:c2:c3:c4", "3")
    @test_4 = OrganCooker::RankTypeFlute.new("grosse Tierce", "1 3/5", "50", "5", r, p, first_note: "C2")
  end

  describe "#name" do
    it "should return capitalized words with height" do
      @test_1.name.must_equal "Montre 8'"
      @test_2.name.must_equal "Flûte Harmonique 8'"
      #@test_2.name.must_equal "Bourdon 8'"
    end

    # it "should return capitalized words with roman number of rows" do
    #   @test_3.name.must_equal "Plein Jeu I-III"
    # end

    it "should return capitalized words with fraction" do
      @test_4.name.must_equal "Grosse Tierce 1'3/5"
    end
  end

  describe "#sizes" do
    it "should return an array of inside diameters" do
      @test_1.sizes.must_equal [145, 140, 135, 130, 125, 120, 116, 112, 108, 104, 100, 96, 93, 89, 86, 83, 80, 77, 74, 71, 69, 66, 64, 61, 59, 57, 55, 53, 51, 49, 47, 46, 44, 42, 41, 39, 38, 36, 35, 34, 33, 31, 30, 29, 28, 27, 26, 25, 24, 23, 22, 22, 21, 20, 19, 19]
    end

    it "should return an array of inside diameters with different progressions" do
      @test_2.sizes.must_equal [83, 81, 79, 77, 76, 74, 72, 71, 69, 68, 66, 65, 63, 62, 60, 59, 58, 56, 55, 53, 52, 50, 49, 47, 46, 45, 43, 42, 41, 40, 39, 38, 36, 35, 34, 33, 32, 32, 31, 30, 29, 28, 27, 27, 26, 25, 24, 24, 23]
    end

    it "should return an array of inside diameters with different progressions & sizes" do
      @test_3.sizes.must_equal [83, 81, 79, 77, 76, 74, 72, 71, 69, 68, 66, 65, 63, 62, 60, 59, 58, 56, 55, 54, 53, 51, 50, 49, 48, 47, 46, 45, 44, 83, 80, 76, 73, 70, 67, 65, 62, 59, 57, 55, 52, 50, 48, 46, 44, 42, 41, 39, 37, 36, 34, 33, 32, 30, 29, 28, 27, 26, 25, 24, 23]
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

  describe "#lengths" do
    it "should return an array of sizes" do
      @test_1.lengths.must_equal [2618, 2471, 2332, 2201, 2078, 1961, 1851, 1747, 1649, 1556, 1469, 1387, 1309, 1235, 1166, 1101, 1039, 981, 925, 874, 825, 778, 735, 693, 654, 618, 583, 550, 519, 490, 463, 437, 412, 389, 367, 347, 327, 309, 292, 275, 260, 245, 231, 218, 206, 195, 184, 173, 164, 154, 146, 138, 130, 123, 116, 109]
      @test_4.lengths.must_equal [262, 247, 233, 220, 208, 196, 185, 175, 165, 156, 147, 139, 131, 124, 117, 110, 104, 98, 93, 87, 82, 78, 73, 69, 65, 62, 58, 55, 52, 49, 46, 44, 41, 39, 37, 35, 33, 31, 29, 28, 26, 25, 23, 22, 21, 19, 18, 17, 16]
    end
  end
end
