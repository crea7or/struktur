"""Contract-parser regressions; no simulator, Memory or Placement execution."""
import unittest
from generate_display_limits import requirement_limits_match, formatted

class RangeContracts(unittest.TestCase):
    def check(self, text, pairs, *, field=None, refs=None):
        field=field or {'id':'current_speed','format':'float'}
        contexts=[{'statute':statute,'intervals':[{'min':a,'max':b}]} for statute,a,b in pairs]
        return requirement_limits_match(text,{'contexts':contexts},field,[],refs)
    def test_canonical_range(self):
        self.assertTrue(self.check('Normal display range: 0 to 200, in selected units.',[(False,0,200),(True,0,200)]))
    def test_mismatch_in_later_context_fails(self):
        self.assertFalse(self.check('Normal display range: 0 to 200.',[(False,0,200),(True,0,199)]))
    def test_field_range_reference(self):
        text='The normal display range is defined by [[FR-16455]].'
        refs={'FR-16455':'The app must display canonical grade from -99.9 to 99.9 percent.'}
        self.assertTrue(self.check(text,[(False,-99.9,99.9)],field={'id':'grade','format':'float'},refs=refs))
        self.assertFalse(self.check(text,[(False,-99.9,99.9)],field={'id':'grade','format':'float'}))
    def test_temperature_units(self):
        text='The normal display range is defined by [[FR-16459]].'
        refs={'FR-16459':'The app must display -40 to 60 C or -40 to 140 F without overflow.'}
        self.assertTrue(self.check(text,[(False,-40,60),(True,-40,140)],field={'id':'temperature','format':'float'},refs=refs))
        self.assertFalse(self.check(text,[(True,-40,60)],field={'id':'temperature','format':'float'},refs=refs))
    def test_full_day_is_not_12_hour_text(self):
        self.assertTrue(self.check('Normal display range: the full day, from 00:00 through 23:59 in 24-hour notation.',[(False,0,1439)],field={'id':'time_of_day','format':'clock'}))
    def test_duration(self):
        self.assertTrue(self.check('Normal display range: 0:00:00 to 99:59:59 elapsed h:mm:ss.',[(False,0,359999)],field={'id':'activity_timer','format':'duration'}))
    def test_duration_seconds_boundary(self):
        field={'format':'duration','unit':''}
        for seconds,expected in [(0,('00','.00')),(65,('01','.05')),
                                 (3599,('59','.59')),(3600,('1:00','')),
                                 (3601,('1:00','')),(35999,('9:59','')),
                                 (36000,('10:00','')),(360000,('100:00',''))]:
            with self.subTest(seconds=seconds):
                self.assertEqual(expected,formatted(field,seconds))
    def test_missing_and_ambiguous_ranges_fail(self):
        self.assertFalse(self.check('No range.',[(False,0,200)]))
        self.assertFalse(self.check('Normal display range: 0 to 200 or 0 to 300.',[(False,0,200)]))

if __name__=='__main__': unittest.main()
