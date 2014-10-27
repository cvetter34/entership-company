module ApplicationHelper

  def check_boxes_for_company_sector(obj, att)
    out = ""

    checked = @current_company.nil? ? [] : @current_company.sectors

    Company.ok_sectors.each_with_index do |sector, index|
      cb = check_box_tag(
        "#{obj.underscore}[#{att.underscore}][]",
        sector[1],
        checked.include?( sector[1] ),
        id: "#{obj.underscore}_#{att.underscore}_#{index}"
      )
      out += content_tag(:div,
        content_tag(:label,
          "#{cb} #{sector[0]}".html_safe,
          for: "#{obj.underscore}_#{att.underscore}_#{index}"
        ),
        class: "checkbox"
      )
    end

    out.html_safe
  end

  def options_for_company_sector(sector = nil)
    company_sectors = [ [ "Select a sector:", "" ] ] + Company.ok_sectors.to_a
    sector ? options_for_select( company_sectors, sector ) : options_for_select( company_sectors )
  end

  def options_for_company_type(company_type = nil)
    company_types = [ [ "Select a company type:", "" ] ] + Company.ok_company_types.to_a
    company_type ? options_for_select( company_types, company_type ) : options_for_select( company_types )
  end

  def options_for_company_size(company_size = nil)
    company_sizes = [ [ "Select a company size:", "" ] ] + Company.ok_company_sizes.to_a
    company_size ? options_for_select( company_sizes, company_size ) : options_for_select( company_sizes )
  end

  def options_for_contract_type(contract_type = nil)
    contract_types = [ [ "Select a contract type:", "" ] ] + Job.ok_contract_types.to_a
    contract_type ? options_for_select( contract_types, contract_type ) : options_for_select( contract_types )
  end

  def options_for_experience_level(experience_level = nil)
    experience_levels = [ [ "Select an experience level:", "" ] ] + Job.ok_experience_levels.to_a
    experience_level ? options_for_select( experience_levels, experience_level ) : options_for_select( experience_levels )
  end

  def flash_noty_script_tag
    javascript_tag(
      %{
        $(function() {
          #{ flash_to_noties.compact.join(" ") }
        });
      }.squish
    ) unless flash.empty?
  end

  private

  def get_type(name)
    name.to_sym == :notice ? "success" : "error"
  end

  def get_timeout(name)
    name.to_sym == :notice ? 4000 : 30000
  end

  def errors_to_ul(errors)
    content_tag(:ul,
      errors.to_a.map do |message|
        content_tag( :li, message ) unless message.blank?
      end.compact.join.html_safe
    ) unless errors.empty?
  end

  def get_text(message)
    message.is_a?(ActiveModel::Errors) ? errors_to_ul(message) : message
  end

  def flash_to_noties
    flash.map do |name, message|
      if ["notice", "alert"].include?(name) &&
          (message.is_a?(String) || message.is_a?(ActiveModel::Errors))
        get_noty_call get_type(name), get_timeout(name), get_text(message)
      end
    end
  end

  def get_noty_call(type, timeout, text)
    %{
      noty({
        layout: "bottomRight",
        type: "#{type}",
        timeout: "#{timeout.to_s}",
        text: "#{text}"
      });
    }.squish
  end
end
