# TODO
class Integer
  def to_kansuji
    s_num = %w[零 一 二 三 四 五 六 七 八 九]
    m_num = %w[十 百 千]
    l_num = %w[万 億 兆 京 垓 𥝱 穣 溝 澗 正 載 極 恒河沙 阿僧祇 那由他 不可思議 無量大数]
    return '零' if self.zero?
    numbers = []
    self.to_s.each_char { |num| numbers << num.to_i }
    blocks = numbers.reverse.each_slice(4).to_a.reverse
    japanese = ''
    blocks.each_with_index do |block, index|
      str = ''
      block.each_with_index do |num, unit|
        next if num.zero?
        str += m_num[unit - 1] if unit.nonzero?
        str += s_num[num] if num == 1 && unit.zero? && (index != blocks.size - 1 || str.size.zero?)
        str += s_num[num] if num > 1
      end
      japanese += str.reverse
      japanese += l_num[blocks.size - (index + 2)] if str.size.nonzero? && blocks.size != index + 1
    end
    japanese
  end
end
# TODO
class String
  def to_number
    s_num = { '〇' => 0, '壹' => 1, '一' => 1, '二' => 2, '三' => 3, '四' => 4, '五' => 5, '六' => 6, '七' => 7, '柒' => 7, '八' => 8, '九' => 9,
              '零' => 0, '壱' => 1, '弐' => 2, '貳' => 2, '参' => 3, '肆' => 4, '伍' => 5, '陸' => 6, '漆' => 7, '捌' => 8, '玖' => 9, '' => 1 }
    m_num = { '十' => 10, '百' => 100, '千' => 1000, '' => 1, '拾' => 10, '佰' => 100, '阡' => 1000, '仟' => 1000 }
    l_num = { '万' => 10**4, '億' => 10**8, '兆' => 10**12, '' => 1, '萬' => 10**4, '京' => 10**16, '垓' => 10**20, '𥝱' => 10**24,
              '秭' => 10**24, '穣' => 10**28, '溝' => 10**32, '澗' => 10**36, '正' => 10**40, '載' => 10**44, '極' => 10**48,
              '恒河沙' => 10**52, '阿僧祇' => 10**56, '那由他' => 10**60, '那由多' => 10**60, '不可思議' => 10**64, '無量大数' => 10**68 }
    reg_m_num = /([^#{m_num.keys.join('')}]*)([#{m_num.keys.join('')}]?)/
    arr_s = self.gsub(/\s+|\d+/, '').scan(/([^#{l_num.keys.join('')}]*)([^#{(s_num.keys + m_num.keys).join('')}]*)/)
    arr_s.inject(0) do |total, (sub_s, l_num_key)|
      sum = sub_s.scan(reg_m_num).inject(-1) { |t, (v1, v2)| t + s_num[v1].to_i * m_num[v2].to_i }
      total + sum * l_num[l_num_key].to_i
    end
  end
end