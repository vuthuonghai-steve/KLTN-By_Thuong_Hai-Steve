import React from 'react';
import { NeoCard, NeoInput, NeoButton } from '../components/UI';
import { EyeOff } from 'lucide-react';
import { useNavigate } from 'react-router-dom';

export const Login: React.FC = () => {
    const navigate = useNavigate();

    const handleLogin = (e: React.FormEvent) => {
        e.preventDefault();
        navigate('/');
    }

  return (
    <div className="min-h-screen w-full bg-neo-bg flex items-center justify-center p-4 relative overflow-hidden">
      {/* Decorative lines */}
      <div className="absolute top-20 right-0 w-64 h-1 bg-black rotate-45 transform origin-center"></div>
      <div className="absolute bottom-20 left-0 w-64 h-1 bg-black -rotate-45 transform origin-center"></div>
      
      <div className="absolute top-4 left-4 font-mono text-xs">
        <p>// init: register_form</p>
        <p>/* auth_module v1.0 */</p>
      </div>

      <NeoCard className="w-full max-w-md relative z-10 p-8 shadow-hard-lg">
        <div className="text-center mb-8">
          <h1 className="text-4xl md:text-5xl font-black uppercase tracking-tighter mb-2">TẠO TÀI KHOẢN</h1>
          <p className="font-mono text-sm text-gray-600">Gia nhập ngay để kết nối.</p>
        </div>

        <form className="space-y-6" onSubmit={handleLogin}>
          <NeoInput label="EMAIL" placeholder="email@example.com" type="email" />
          <NeoInput label="TÊN NGƯỜI DÙNG" placeholder="Tên của bạn" />
          
          <div className="relative">
             <NeoInput label="MẬT KHẨU" placeholder="Nhập mật khẩu của bạn" type="password" />
             <button type="button" className="absolute right-3 bottom-3 p-1">
               <EyeOff size={18} />
             </button>
          </div>

          <NeoButton fullWidth size="lg" className="mt-4" type="submit">
            GIA NHẬP
          </NeoButton>
        </form>

        <div className="mt-6 text-center">
          <p className="font-mono text-sm">
            Đã có tài khoản? <span className="font-bold underline cursor-pointer hover:text-neo-primary" onClick={() => navigate('/')}>{`> Đăng nhập`}</span>
          </p>
        </div>
      </NeoCard>
      
      <div className="absolute bottom-4 right-4 font-mono text-xs text-right">
        <p>{`<!-- status: ok -->`}</p>
        <p>// session: active</p>
      </div>
    </div>
  );
};
