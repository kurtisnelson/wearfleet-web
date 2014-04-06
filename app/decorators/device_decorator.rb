class DeviceDecorator < Draper::Decorator
  delegate_all
  decorates :device

  def fleet_name
    return object.fleet.name if object.fleet
    "None"
  end
end
