require_relative 'shared'
require 'roman'

module OrganCooker

  ##
  # Defines a flute-type rank. That means with opened pipes.
  class RankTypeFlute

    ##
    # An array of +toe_holes+ diameters.
    attr_accessor :toe_holes

    include OrganCooker::Shared

    @@alpha_notes = %w(C C# D D# E F F# G G# A A# B)

    ##
    # Initialize an OrganCooker::RankTypeFlute object with these parameters :
    # [name]              a name (ex: "montre")
    # [heigth]            the height (in feet) for the lowest pipe (ex: "4")
    # [size]              the size (internal diameter) for the lowest pipe (ex: "145")
    # [progression]       the progression
    # [windchest_object]  an OrganCooker::WindChest object that the rank belongs to
    # [project_object]    an OrganCooker::Project object that the rank belongs to
    # [first_note]        the lowest note (if different than the one in OrganCooker::WindChest)
    # ====Example :
    #   w = OrganCooker::WindChest.new("grand-orgue", "56", "c0")
    #   p = OrganCooker::Project.new("mantes-la-jolie", "15", "435")
    #   r = OrganCooker::RankTypeFlute.new("montre", "8", "145", "6", w, p, "c2")
    def initialize(name, height, size, progression, windchest_object, project_object, first_note=windchest_object.instance_variable_get(:@first_note))
      @name       = name
      @height     = height
      @size       = size
      @prog       = progression
      @windchest  = windchest_object
      @project    = project_object
      @first_note = first_note
    end

    ##
    # Returns an array of frequencies for each notes based on OrganCooker::Project diapason.
    def frequencies
      frequencies = []
      height      = height_decimal(@height)
      semi_tons   = semi_tons_from_A3_to(@first_note)
      diapason    = @project.instance_variable_get(:@diapason)

      notes.count.times do
        frequencies << (diapason.to_f * 2**(semi_tons.to_f / 12)) / (height / 8.0)
        semi_tons += 1
      end
      frequencies
    end

    ##
    # Returns an array of lengths for each pipes.
    def lengths
      frequencies.map { |frequency| (@project.speed_of_sound / (frequency * 2) * 1000) }
    end

    ##
    # Returns an array of sizes (internal diameters).
    def sizes
      h_sizes   = [@size.to_i]
      prog      = @prog
      add_sizes = Proc.new { h_sizes << h_sizes.last / prog.to_f**(1.0 / 48) }
      nb_notes  = notes.count

      if @prog.include?(':')
        progs = @prog.split(':')
        index = notes.index(@note_chang_prog.upcase)
        prog  = progs[0]
        index.times(&add_sizes)
        prog  = progs[1]
        (nb_notes - index - 1).times(&add_sizes)
      else
        (nb_notes - 1).times(&add_sizes)
      end
      h_sizes.map! { |size| size.round(0) }
    end

    ##
    # Returns an array of rank's notes.
    def notes
      octave = info_note(@first_note)[:octave]
      index  = @@alpha_notes.index(info_note(@first_note)[:letter])
      a_notes  = []

      until a_notes.include?(last_note) do
        if index == 12
          octave += 1
          index  = 0
        end
        a_notes << "#{@@alpha_notes[index]}#{octave}"
        index += 1
      end
      a_notes
    end

    private

    ##
    # Returns the last note of the rank.
    def last_note
      note   = @windchest.instance_variable_get(:@first_note).upcase
      octave = info_note(note)[:octave]
      index  = @@alpha_notes.index(info_note(note)[:letter])

      (@windchest.instance_variable_get(:@nb_notes).to_i - 1).times do
        if index == 12
          octave += 1
          index = 0
        end
        index += 1
      end
      if index == 12
        octave += 1
        index = 0
      end
      "#{@@alpha_notes[index]}#{octave}"
    end

    ##
    # Finds the number of semi-tons from A3 to a given note.
    def semi_tons_from_A3_to(note)
      note    = note.upcase
      octave  = info_note(note)[:octave]
      index   = @@alpha_notes.index(info_note(note)[:letter])
      a_notes = []

      if note == 'A#3' || note == 'B3' || octave > 3
        octave = 3
        index  = @@alpha_notes.index('A')
        until a_notes.include?(note) do
          if index == 12
            octave += 1
            index  = 0
          end
          a_notes << "#{@@alpha_notes[index]}#{octave}"
          index += 1
        end
        return a_notes.index(note)
      else
        until a_notes.include?('A3') do
          if index == 12
            octave += 1
            index  = 0
          end
          a_notes << "#{@@alpha_notes[index]}#{octave}"
          index += 1
        end
        -a_notes.index('A3')
      end
    end

    ##
    # Returns a float height for a fraction entry (ex: 2'2/3).
    def height_decimal(height)
      if height.include?('/')
        chiffres = height.scan(/\d+/).map { |i| i.to_f }
        chiffres[0] + chiffres[1] / chiffres[2]
      else
        height.to_f
      end
    end

    ##
    # Splits letter and octave of a given note in a hash.
    def info_note(note)
      { letter: note[/[^-\d]+/].upcase, octave: note[/-?\d+/].to_i }
    end
  end

  ##
  # Cette classe permet de créer un jeu de type "Bourdon" (jeux bouchés).
  class RankTypeBourdon

    def longueurs(diviseur: 2)
      super
    end
  end

  # Cette classe permet de créer un jeu de type "Fournitures"
  # avec plusieurs rangs et des reprises.
  class RankTypeMixtures

    # Initialisation des instances.
    def initialize(name, height, size, prog, nb_notes, start_note, sound_speed, diapason, notes_reprises, nb_rows)
      super(name, height, size, prog, nb_notes, start_note, sound_speed, diapason)
      @notes_reprises = notes_reprises
      @nb_rows       = nb_rows
    end

    # Méthode pour avoir le name complet du jeu.
    def nom
      name   = @name.split.each { |mot| mot.capitalize! }.join(' ')
      rangs = @nb_rangs.scan(/\d+/).map { |rang| rang = rang.to_i.to_roman.to_s }.join('-')
      "#{name} #{rangs}"
    end

    def diams_ext
      diams_ext = {}
      sizes.each do |rang, tab_sizes|
        diams_ext[rang] = tab_sizes.map do |size|
          if size == '-'
            size
          else
            ep_metal = 0.3
            diam_ref = 10
            until size <= diam_ref
              ep_metal += 0.05
              diam_ref += 5
            end
            size + (ep_metal.round(2) * 2)
          end
        end
      end
      diams_ext
    end

    def sizes(typejeu: Rank)
      h_sizes    = {}
      all_height = []
      nb_notes   = (@nb_notes.to_i + 24).to_s

      @height.each_value do |tab_height_par_rang|
        all_height.concat(tab_height_par_rang)
      end
      all_height.uniq!
      height_deci     = all_height.map { |nombre| height_decimal(nombre) }
      index           = height_deci.index(height_deci.max)
      plus_haut_pieds = all_height[index]

      exemple = typejeu.new(@nom, plus_haut_pieds, @size, @prog, nb_notes, @start_note, @sound_speed, @diapason)

      longueurs().each do |rang, tab_longueurs|
        sizes_par_rang = []
        tab_longueurs.each do |longueur|
          if longueur == '-'
            sizes_par_rang << longueur
          else
            index = plus_proche_de(longueur, exemple.longueurs)
            sizes_par_rang << exemple.h_sizes[index]
          end
        end
        h_sizes[rang] = sizes_par_rang
      end
      h_sizes
    end

    def frequences
      frequences = {}
      objets_par_rang().each do |rang, objets|
        frequences[rang] = []
        objets.each do |objet|
           objet == '-' ? frequences[rang] << objet : frequences[rang].concat(objet.frequences)
        end
      end
      return frequences
    end

    def longueurs(diviseur: 1)
      longueurs = {}
      frequences().each do |rang, tab_freqs|
        longueurs[rang] = tab_freqs.map { |frequence| frequence == '-' ? frequence : (@sound_speed / (frequence * 2) * 1000) / diviseur }
      end
      longueurs
    end

    private

    def objets_par_rang(typejeu: RankTypeFlute)
      objets = {}
      @height.each do |rang, height|
        index    = 0
        objets_par_rang = []
        height.each do |h|
          nb_notes    = reprises[:nb_notes][index]
          start_note = reprises[:notes][index]
          if h == '-'
            nb_notes.times { |i| objets_par_rang << '-'}
          else
            objet = typejeu.new(@nom, h, @size, @prog, nb_notes, start_note, @sound_speed, @diapason)
            objets_par_rang << objet
          end
          index += 1
        end
        objets[rang] = objets_par_rang
      end
      objets
    end

    # Renvoi la note de départ et les notes de reprises,
    # ainsi que l'écart entre chaque note.
    def reprises
      reprises = {}
      notes_reprises = @notes_reprises.split(':').each { |reprise| reprise.upcase! }.unshift(notes.first).uniq
      h_sizes = []
      notes_reprises.size.times do |index|
        start = notes.index(notes_reprises[index])
        if index == notes_reprises.index(notes_reprises.last)
          stop = notes.index(notes.last)
          size = notes[start..stop].size
        else
          stop = notes.index(notes_reprises[index + 1])
          size = notes[start...stop].size
        end
        h_sizes << size
      end
      reprises = {
        notes:    notes_reprises,
        nb_notes: h_sizes
      }
      reprises
    end

    # Permet de trouver la valeur d'un tableau la plus proche d'une valeur donnée.
    def plus_proche_de(num, tab)
      if num >= tab.max
        return tab.index(tab.max)
      elsif num <= tab.min
        return tab.index(tab.min)
      else
        a = tab.map { |x| (x - num).abs }
        index = a.index(a.min)
        return index
      end
    end
  end

  # Cette classe permet de créer un jeu de type "Cornet"
  # (donc bouché) avec plusieurs rangs et des reprises.
  class RankTypeCornet

    def longueurs(diviseur: 2)
      super
    end

    private

    def objets_par_rang(typejeu: RankTypeBourdon)
      super
    end
  end
end
