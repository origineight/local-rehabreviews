module PagesHelper
  
  def state_coords(state)
    if all_states[state]
      lat = all_states[state]["latitude"]
      lng = all_states[state]["longitude"]
      zoom = all_states[state]["zoom"]
      state_coords = [lat,lng,zoom]
    else
      state_coords = [37.6,-95.665,5]
    end
    state_coords
  end

  def state_full_name(state)
    all_states[state]["full_state"]
  end

  def all_services
    services = ["outpatient_only", "inpatient", "outpatient", "day_treatment", "day_treatment_only"]
    services
  end

  def services_offered_key(key)
    services_offered = {
      "outpatient_only" => "Outpatient Only",
      "inpatient" => "Inpatient",
      "outpatient" => "Outpatient",
      "day_treatment" => "Day Treatment",
      "day_treatment_only" => "Day Treatment Only"
    }
    if services_offered[key]
      services_offered[key]
    else
      key.gsub("_", " ").titleize
    end
  end

end