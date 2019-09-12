namespace :drip_therapists do
  desc "This task imports the fourth batch of therapists, ~300,000 listings"
  task :batch_4 => :environment do
    t = 0
    (0..740).each do |i|
      url = "http://rehab-reviews.s3.amazonaws.com/assets/therapists/all_therapists-#{i}.json"
      response = HTTParty.get(url)
      puts "got file ##{i+1}!"
      data = JSON.parse(response.body)
      puts 'parsed!'
      data.each_with_index do |obj,j|
        array = [0, 1, 6, 7, 9, 11, 17, 18, 21, 22, 24, 29, 32, 36, 44, 46, 47, 50, 55, 56, 57, 59, 62, 63, 64, 66, 67, 69, 70, 72, 76, 78, 79, 80, 82, 85, 88, 90, 102, 106, 108, 109, 110, 113, 115, 119, 124, 131, 132, 134, 136, 140, 143, 147, 149, 150, 152, 153, 155, 160, 161, 164, 173, 176, 178, 180, 182, 183, 184, 185, 187, 189, 190, 191, 192, 195, 196, 198, 200, 204, 206, 207, 208, 210, 214, 215, 218, 225, 228, 229, 231, 235, 238, 241, 242, 246, 247, 249, 252, 253, 255, 260, 261, 263, 264, 266, 270, 275, 276, 277, 278, 282, 286, 288, 289, 295, 298, 301, 302, 305, 307, 310, 312, 313, 314, 316, 317, 319, 321, 324, 325, 326, 327, 329, 334, 335, 338, 344, 349, 350, 352, 355, 356, 357, 359, 362, 363, 364, 367, 370, 372, 373, 376, 379, 380, 381, 383, 388, 391, 392, 398, 399, 401, 403, 407, 409, 411, 413, 415, 417, 418, 419, 421, 422, 423, 424, 428, 430, 432, 433, 434, 438, 440, 443, 445, 452, 457, 459, 460, 461, 464, 468, 469, 471, 474, 478, 480, 481, 483, 485, 486, 493, 495, 496, 497, 501, 505, 506, 511, 512, 513, 514, 515, 517, 519, 522, 523, 527, 528, 530, 536, 538, 539, 540, 542, 543, 556, 565, 567, 569, 570, 571, 576, 578, 580, 581, 583, 587, 589, 590, 597, 601, 603, 604, 606, 607, 612, 614, 616, 618, 619, 622, 624, 627, 629, 632, 635, 636, 639, 640, 645, 647, 648, 650, 651, 655, 657, 658, 659, 668, 671, 673, 681, 684, 685, 686, 687, 695, 696, 697, 699, 704, 705, 707, 711, 714, 716, 719, 720, 724, 726, 727, 730, 732, 737, 741, 742, 744, 747, 751, 753, 754, 759, 760, 763, 764, 766, 769, 770, 774, 777, 779, 780, 784, 786, 787, 788, 790, 792, 794, 795, 796, 797, 800, 803, 804, 807, 808, 809, 810, 811, 812, 813, 814, 815, 818, 821, 823, 826, 837, 840, 844, 845, 847, 849, 851, 852, 853, 854, 856, 857, 859, 862, 867, 868, 869, 871, 875, 878, 879, 881, 889, 892, 893, 895, 897, 899, 903, 904, 905, 906, 911, 913, 914, 916, 924, 926, 928, 932, 935, 936, 938, 941, 942, 943, 947, 952, 958, 960, 966, 967, 968, 971, 975, 976, 977, 978, 979, 980, 985, 992, 993, 996, 997, 999]
        if array.include? j
          l = Listing.new obj
          l.geocode
          # fallback to zip code geocoding
          if l.zipcode.size < 5
            l.zipcode = l.zipcode.rjust(5, '0')
          end
          unless l.geocoded?
            zip = Zipcode.find_by(postal: l.zipcode)
            if zip
              l.latitude = zip.latitude
              l.longitude = zip.longitude
            else
              # fallback to state geocoding
              a = ApplicationController.new
              if a.all_states[l.state.downcase].present?
                l.latitude = a.all_states[l.state.downcase]['latitude']
                l.longitude = a.all_states[l.state.downcase]['latitude']
              else
                # fallback to default U.S. geocode values
                l.latitude = 38.8833
                l.longitude = 77.0167
              end
            end
          end
          t = t + 1
          l.published = true
          logger ||= Logger.new("#{Rails.root}/log/therapists.log")
          if l.valid?
            l.save
            puts "Imported Listing with ID #{l.id} – ##{t} of ~300,000"
          else
            failure_msg = "Failed import from listing '#{l.full_name}' - File: all_therapists-#{i}.json - Item: #{j}"
            puts failure_msg
            logger.error failure_msg
            logger.debug l.errors.messages
          end
        end
      end
    end
  end
end
