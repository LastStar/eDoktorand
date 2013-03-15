module ServiceTools
  class DisertTheme
    def self.for_sending(disert_theme)
      {
        :id_prace => disert_theme.id,
        :nazev_cz => disert_theme.title,
        :nazev_en => disert_theme.title_en,
        :student_UIC => disert_theme.index.student.uic,
        :vedouci_UIC => disert_theme.index.tutor.uic,
        :termin_obhajoby => disert_theme.defense_passed_on.strftime('%Y-%m-%d 00:00:00'),
        :fakulta => disert_theme.index.faculty.code,
        :utvar => disert_theme.index.department.code,
        :obor => disert_theme.index.specialization.code,
        :prace_URL => "http://edoktorand.czu.cz/pdf/disert_theme/#{disert_theme.id}.pdf",
        :autoreferat_URL => "http://edoktorand.czu.cz/pdf/self_report/#{disert_theme.id}.pdf",
        :posudek_oponent_URL => "http://edoktorand.czu.cz/pdf/opponent_review/#{disert_theme.id}.pdf"
      }
    end
  end
end
