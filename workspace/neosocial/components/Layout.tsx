import React from 'react';
import { NavLink, Outlet, useLocation } from 'react-router-dom';
import { Home, User, Settings, Search, PlusSquare, Menu, LogOut, Layers } from 'lucide-react';
import { NeoButton } from './UI';

export const Layout: React.FC = () => {
  const location = useLocation();
  const isLoginPage = location.pathname === '/login';

  if (isLoginPage) {
    return <Outlet />;
  }

  const navItems = [
    { icon: <Home size={20} />, label: "Home", path: "/" },
    { icon: <Search size={20} />, label: "Explore", path: "/explore" },
    { icon: <PlusSquare size={20} />, label: "Create", path: "/create" },
    { icon: <User size={20} />, label: "Profile", path: "/profile" },
    { icon: <Settings size={20} />, label: "Settings", path: "/settings" },
    { icon: <Layers size={20} />, label: "UI Kit", path: "/components" },
  ];

  return (
    <div className="min-h-screen flex flex-col md:flex-row max-w-[1600px] mx-auto border-x-2 border-black bg-neo-bg">
      {/* Sidebar - Desktop */}
      <aside className="hidden md:flex w-64 flex-col border-r-2 border-black sticky top-0 h-screen bg-neo-bg">
        <div className="p-6 border-b-2 border-black">
          <h1 className="text-3xl font-black uppercase italic tracking-tighter">NEO-SOCIAL</h1>
        </div>
        
        <nav className="flex-1 p-4 flex flex-col gap-3">
          {navItems.map((item) => (
            <NavLink 
              key={item.path} 
              to={item.path}
              className={({ isActive }) => 
                `flex items-center gap-3 px-4 py-3 font-bold border-2 border-black transition-all hover:-translate-y-1 hover:shadow-hard ${
                  isActive ? 'bg-neo-primary shadow-hard' : 'bg-white shadow-hard-sm'
                }`
              }
            >
              {item.icon}
              <span className="uppercase">{item.label}</span>
            </NavLink>
          ))}
        </nav>

        <div className="p-4 border-t-2 border-black">
           <NavLink to="/login">
            <NeoButton variant="ghost" fullWidth className="justify-start">
              <LogOut size={20} />
              Logout
            </NeoButton>
           </NavLink>
        </div>
      </aside>

      {/* Mobile Header */}
      <header className="md:hidden flex items-center justify-between p-4 border-b-2 border-black bg-neo-bg sticky top-0 z-50">
        <h1 className="text-2xl font-black uppercase italic tracking-tighter">NEO-SOCIAL</h1>
        <button className="p-2 border-2 border-black bg-white shadow-hard-sm active:translate-y-1 active:shadow-none">
          <Menu size={24} />
        </button>
      </header>

      {/* Main Content */}
      <main className="flex-1 overflow-y-auto">
        <Outlet />
      </main>

      {/* Mobile Bottom Nav */}
      <nav className="md:hidden fixed bottom-0 left-0 right-0 bg-white border-t-2 border-black p-2 flex justify-around z-50">
         {navItems.slice(0, 5).map((item) => (
            <NavLink 
              key={item.path} 
              to={item.path}
              className={({ isActive }) => 
                `p-3 rounded-none border-2 ${isActive ? 'bg-neo-primary border-black' : 'border-transparent text-gray-500'}`
              }
            >
              {item.icon}
            </NavLink>
          ))}
      </nav>
    </div>
  );
};
