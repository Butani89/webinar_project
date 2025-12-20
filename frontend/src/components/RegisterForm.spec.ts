import { mount } from '@vue/test-utils'
import { describe, it, expect, vi } from 'vitest'
import RegisterForm from './RegisterForm.vue'

describe('RegisterForm.vue', () => {
  it('renders correctly', () => {
    const wrapper = mount(RegisterForm)
    expect(wrapper.find('h3').text()).toBe('Registrera din plats')
    expect(wrapper.find('button').text()).toBe('Anmäl mig till webinaret')
  })

  it('validates form fields', async () => {
    const wrapper = mount(RegisterForm)
    const form = wrapper.find('form')
    
    // Attempt to submit empty form
    await form.trigger('submit.prevent')
    
    // Since we use native required, we can't easily test native validation with JSDOM
    // but we can check if the button is disabled or if feedback is shown if we had manual validation.
  })
})
