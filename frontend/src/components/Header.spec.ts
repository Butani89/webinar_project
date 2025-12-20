import { mount } from '@vue/test-utils'
import { describe, it, expect } from 'vitest'
import Header from './Header.vue'

describe('Header.vue', () => {
  it('renders title correctly', () => {
    const wrapper = mount(Header)
    expect(wrapper.text()).toContain('Svamparnas Fascinerande Värld')
  })
})
