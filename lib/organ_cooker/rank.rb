require 'roman'

module OrganCooker

  ##
  # Defines a +flute-type rank+. That means with opened pipes.
  class RankTypeFlute

    ##
    # Gets the +toe holes+ of the rank
    ##
    # @overload toe_holes
    #   Gets the current toe holes
    #   @api public
    # @overload toe_holes=(value)
    #   Sets the new toe holes
    #   @api public
    #   @param value [Array<Integer>, Nil] the new toe holes
    # @return [Array<Integer>, Nil] the toe holes
    attr_accessor :toe_holes

    ##
    # Initialize a +flute-type rank+ object
    # @param name [String] a name (ex: "montre")
    # @param height [String] the height (in feet) for the lowest pipe (ex: "4", "2 2/3")
    # @param size [String, Numeric] the size (internal diameter) for the lowest pipe
    #   (ex: "145")
    # @param progression [String, Numeric] the progression
    # @param windchest_object [OrganCooker::WindChest] the windchest object that
    #   the rank belongs to
    # @param project_object [OrganCooker::Project] the project object that the
    #   rank belongs to
    # @param first_note [String] (optional) the lowest note (if different than
    #   the windchest's one)
    # @param prog_change [OrganCooker::Note] (optional) the note where progression is changing
    # @example
    #   w = OrganCooker::WindChest.new("grand-orgue", "56", "c0")
    #   p = OrganCooker::Project.new("mantes-la-jolie", "15", "435")
    #   r = OrganCooker::RankTypeFlute.new("montre", "8", "145", "6", w, p, first_note: "c2")
    def initialize(name, height, size, progression, windchest_object, project_object, first_note: windchest_object.first_note, prog_change: {note: nil, size: nil})
      @name        = name
      @height      = height
      @size        = size
      @prog        = progression
      @windchest   = windchest_object
      @project     = project_object
      @first_note  = first_note
      @prog_change = prog_change
    end

    ##
    # Returns object +name+ with +height+
    # @api public
    # @return [String] the name of the rank
    # @example
    #   p = OrganCooker::Project.new("mantes-la-jolie", "18", "440")
    #   w = OrganCooker::WindChest.new("grand-orgue", "56", "C1")
    #   r = OrganCooker::RankTypeFlute.new("grosse Tierce", "1 3/5", "50", "5", r, p, first_note: "C2")
    #   r.name #=> "Grosse Tierce 1' 3/5"
    def name
      name = @name.gsub(/[[:alpha:]]+/) { |word| word.capitalize }

      if @height.include? "/"
        numbers = digits_scan(@height).map(&:to_i)
        "#{name} #{numbers[0]}'#{numbers[1]}/#{numbers[2]}"
      else
        "#{name} #{@height}'"
      end
    end

    ##
    # Returns an array of notes +frequencies+
    # @api public
    # @return [Array<Float>] the frequency of each note
    # @example
    #   p = OrganCooker::Project.new("mantes-la-jolie", "18", "440")
    #   w = OrganCooker::WindChest.new("grand-orgue", "56", "C1")
    #   r = OrganCooker::RankTypeFlute.new("grosse Tierce", "1 3/5", "50", "5", w, p, first_note: "C2")
    #   r.frequencies #=> [654.06, 692.96, 734.16, 777.82, 824.07, 873.07, 924.99...]
    def frequencies
      notes_range.to_a.map { |note| note.frequency(diapason: @project.diapason, height: @height).round(2) }
    end

    ##
    # Returns an array of +lengths+ for each pipes
    # @api public
    # @return [Array<Integer>] the length of each note
    # @example
    #   p = OrganCooker::Project.new("mantes-la-jolie", "18", "440")
    #   w = OrganCooker::WindChest.new("grand-orgue", "56", "C1")
    #   r = OrganCooker::RankTypeFlute.new("grosse Tierce", "1 3/5", "50", "5", w, p, first_note: "C2")
    #   r.lengths #=> [654.06, 692.96, 734.16, 777.82, 824.07, 873.07, 924.99...]
    def lengths
      frequencies.map { |frequency| (@project.speed_of_sound / (frequency * 2) * 1000).round(0) }
    end

    ##
    # Returns an array of +sizes+ (internal diameters).
    # @api public
    # @return [Array<Integer>] the length of each note
    # @example
    #   p = OrganCooker::Project.new("mantes-la-jolie", "18", "440")
    #   w = OrganCooker::WindChest.new("grand-orgue", "56", "C1")
    #   r = OrganCooker::RankTypeFlute.new("grosse Tierce", "1 3/5", "50", "5", w, p, first_note: "C2")
    #   r.sizes #=> [50, 48, 47, 45, 44, 42, 41, 40, 38, 37, 36, 35...]
    def sizes
      h_sizes   = [@size.to_i]
      prog      = @prog
      add_sizes = Proc.new { h_sizes << h_sizes.last / prog.to_f**(1.0 / 48) }
      nb_notes  = notes_range.to_a.size

      if @prog_change[:note].nil? && @prog_change[:size].nil?
        (nb_notes - 1).times(&add_sizes)
      elsif @prog_change[:note] != nil
        progs    = digits_scan(@prog)

        prog     = progs[0]
        nb_notes = (notes_range.min.succ..@prog_change[:note].to_note).to_a.size
        nb_notes.times(&add_sizes)

        prog         = progs[1]
        if @prog_change[:size] != nil
          h_sizes.pop
          h_sizes << @prog_change[:size]
        end
        nb_notes     = (@prog_change[:note].to_note.succ..notes_range.max).to_a.size
        nb_notes.times(&add_sizes)
      end

      h_sizes.map { |size| size.round(0) }
    end

    ##
    # Returns an array of rank's +notes+
    # @api public
    # @return [Array<String>] the music notes
    # @example will return notes from A1 (rank) to C2 (windchest's 13th note)
    #   w = OrganCooker::WindChest.new("grand-orgue", "13", "C1")
    #   p = OrganCooker::Project.new("mantes-la-jolie", "18", "440")
    #   f = OrganCooker::RankTypeFlute.new("grosse Tierce", "1 3/5", "50", "5", w, p, "A1")
    #   f.notes #=> ["A1", "A#1", "B1", "C2"]
    def notes
      notes_range.to_a.map(&:to_s)
    end

    private

    ##
    # Returns a +Range+ object from first rank note to last windchest note
    # @api private
    # @return [Range] the music notes range
    # @example
    #   r = OrganCooker::Note.new("c3")..OrganCooker::Note.new("G#6") #=> C3..G#6
    #   r.class #=> Range
    #   r.to_a.size #=> 45
    def notes_range
      (@first_note.to_note..@windchest.last_note)
    end

    ##
    # Returns an array of numbers
    # @api private
    # @return [Array] an array of numbers
    # @example
    #   string = "4 5 78 54 12"
    #   digits_scan(string) #=> ["4", "5", "78", "54", "12"]
    def digits_scan(string)
      string.scan(/[[:digit:]]+\.?[[:digit:]]*/)
    end
  end

  ##
  # Defines a +bourdon-type rank+. That means with closed pipes.
  class RankTypeBourdon < RankTypeFlute

    ##
    # @see RankTypeFlute#lengths
    # @return [Array<Integer>] the length of each note
    def lengths
      super.map { |length| length / 2 }
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
