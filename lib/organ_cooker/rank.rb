require_relative 'shared'
require 'roman'

module OrganCooker

  # This class defines a pipe organ 'rank' with all the parameters needed to
  # work out pipes.
  class RankTypeFlute

    # An array with toe holes diameters.
    attr_accessor :toe_holes

    include OrganCooker::Shared

    @@alpha_notes = %w(C C# D D# E F F# G G# A A# B)

    # Initialization.
    def initialize(name, height, size, prog, nb_notes, start_note, sound_speed, diapason)
      @name        = name
      @height      = height
      @size        = size
      @prog        = prog
      @nb_notes    = nb_notes
      @start_note  = start_note
      @sound_speed = sound_speed
      @diapason    = diapason
    end

    # Returns an array of external pipe's diameters.
    def diams_ext
      sizes().map do |size|
        ep_metal = 0.3
        diam_ref = 10
        until size <= diam_ref
          ep_metal += 0.05
          diam_ref += 5
        end
        size + (ep_metal.round(2) * 2)
      end
    end

    # Returns an array of sizes (int. diameters).
    def sizes
      sizes = [@size.to_i]
      prog  = @prog

      # Création d'un block
      ajouter_sizes = Proc.new { sizes << sizes.last / prog.to_f**(1.0 / 48) }
      if @prog.include?(':')
        progs = @prog.split(':')
        index        = notes().index(@note_chang_prog.upcase)
        prog  = progs[0]
        index.times(&ajouter_sizes)
        prog  = progs[1]
        (@nb_notes.to_i - index - 1).times(&ajouter_sizes)
      else
        (@nb_notes.to_i - 1).times(&ajouter_sizes)
      end
      return sizes.map! { |size| size.round(0) }
    end

    # Méthode permettant de créer un tableau des notes.
    def notes
      octave = info_note(@start_note)[:octave]
      index  = @@alpha_notes.index(info_note(@start_note)[:nom])
      notes  = []
      @nb_notes.to_i.times do
        if index == 12
          octave += 1
          index  = 0
        end
        notes << "#{@@alpha_notes[index]}#{octave}"
        index += 1
      end
      return notes
    end

    # Méthode permettant de créer un tableau des frequences.
    def frequences
      frequences = []
      height    = height_decimal(@height)
      demi_tons  = demi_tons_from_A3_to(@start_note)

      @nb_notes.to_i.times do
        # Fréquences du LA3 * 2**(demi-tons par rapport au LA3 / 12)
        frequences << (@diapason.to_f * 2**(demi_tons.to_f / 12)) / (height / 8.0)
        demi_tons += 1
      end
      return frequences
    end

    # Méthode permettant de créer un tableau des longueurs.
    def longueurs(diviseur: 1)
      return frequences().map { |frequence| (@sound_speed / (frequence * 2) * 1000) / diviseur }
    end

    private

    # Permet de trouver le nb de demi-tons à partir du LA3 (négatif ou positif).
    def demi_tons_from_A3_to(note)
      note   = note.upcase
      octave = info_note(note)[:octave]
      index  = @@alpha_notes.index(info_note(note)[:nom])
      notes  = []

      if note == 'A#3' || note == 'B3' || octave > 3
        octave = 3
        index  = @@alpha_notes.index('A')
        until notes.include?(note) do
          if index == 12
            octave += 1
            index  = 0
          end
          notes << "#{@@alpha_notes[index]}#{octave}"
          index += 1
        end
        return notes.index(note)
      else
        until notes.include?('A3') do
          if index == 12
            octave += 1
            index  = 0
          end
          notes << "#{@@alpha_notes[index]}#{octave}"
          index += 1
        end
        return -notes.index('A3')
      end
    end

    # Création d'un nombre de pieds décimal pour une entrée sous forme de fraction.
    def height_decimal(height)
      if height.include?('/')
        chiffres = height.scan(/\d+/).map { |i| i.to_f }
        chiffres[0] + chiffres[1] / chiffres[2]
      else
        height.to_f
      end
    end

    # Retourne le nom et l'octave d'une note.
    def info_note(note)
      { nom: note[/[^-\d]+/].upcase, octave: note[/-?\d+/].to_i }
    end
  end

  # Cette classe permet de créer un jeu de type "Bourdon" (jeux bouchés).
  class RankTypeBourdon < RankTypeFlute

    # Cette méthode permet de diviser la longueur par 2 pour les jeux bouchés.
    def longueurs(diviseur: 2)
      super
    end
  end

  # Cette classe permet de créer un jeu de type "Fournitures"
  # avec plusieurs rangs et des reprises.
  class RankTypeMixtures < RankTypeFlute

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
      return "#{name} #{rangs}"
    end

    def diams_ext
      diams_ext = {}
      sizes().each do |rang, tab_sizes|
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
      return diams_ext
    end

    def sizes(typejeu: Rank)
      sizes     = {}
      all_height = []
      nb_notes    = (@nb_notes.to_i + 24).to_s
      @height.each_value do |tab_height_par_rang|
        all_height.concat(tab_height_par_rang)
      end
      all_height.uniq!
      height_deci    = all_height.map { |nombre| height_decimal(nombre) }
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
            sizes_par_rang << exemple.sizes[index]
          end
        end
        sizes[rang] = sizes_par_rang
      end
      return sizes
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
      return longueurs
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
            objet = typejeu.new(@nom, h, @size, @prog,
                                nb_notes, start_note, @sound_speed, @diapason)
            objets_par_rang << objet
          end
          index += 1
        end
        objets[rang] = objets_par_rang
      end
      return objets
    end

    # Renvoi la note de départ et les notes de reprises,
    # ainsi que l'écart entre chaque note.
    def reprises
      reprises = {}
      notes_reprises = @notes_reprises.split(':').each { |reprise| reprise.upcase! }.unshift(notes().first).uniq
      sizes = []
      notes_reprises.size.times do |index|
        start = notes().index(notes_reprises[index])
        if index == notes_reprises.index(notes_reprises.last)
          stop = notes().index(notes().last)
          size = notes()[start..stop].size
        else
          stop = notes().index(notes_reprises[index + 1])
          size = notes()[start...stop].size
        end
        sizes << size
      end
      reprises = {
        notes:    notes_reprises,
        nb_notes: sizes
      }
      return reprises
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
  class RankTypeCornet < RankTypeMixtures

    def longueurs(diviseur: 2)
      super
    end

    private

    def objets_par_rang(typejeu: RankTypeBourdon)
      super
    end
  end
end

# m = RankTypeMixtures.new("plein jeu", {:rang1=>["2", "2 2/3", "4", "8"], :rang2=>["-", "2", "2 2/3", "4"], :rang3=>["-", "-", "2", "2 2/3"]}, "84", "7", "56", "c1", 342.426, "440", "c1:c2:c3:c4", "3")
# n = RankTypeCornet.new("plein jeu", {:rang1=>["2", "2 2/3", "4", "8"], :rang2=>["1 1/3", "2", "2 2/3", "4"], :rang3=>["1", "1 1/3", "2", "2 2/3"]}, "84", "7", "56", "c1", 342.426, "440", "c1:c2:c3:c4", "3")
# f = RankTypeFlute.new("montre", "8", "145", "6", "56", "c1", 342.426, "440")
# b = RankTypeBourdon.new("bourdon", "16", "145", "6", "64", "a0", 342.426, "440")
# binding.pry
# 2:2 2/3:4:8
# 1 1/3:2:2 2/3:4
# 1:1 1/3:2:2 2/3
